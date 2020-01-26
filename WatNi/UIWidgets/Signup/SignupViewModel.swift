//
//  SignupViewModel.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation
import Combine

class SignupViewModel: ObservableObject {

    enum InputType {
        case name, email, password, passwordConfirm
    }

    private var name: String = ""
    private var email: String = ""
    private var password: String = ""
    private var passwordConfirm: String = ""

    private var cancelables = Set<AnyCancellable>()

    /// 유효한 이메일 여부
    var isValidEmail: Bool {
        let expression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = email.range(of: expression, options: .regularExpression)

        return result != nil || email.isEmpty
    }

    /// 유효한 비밀번호 여부
    var isValidPassword: Bool {
        return (password.count >= 6 && password.count <= 12) || password.isEmpty
    }

    /// 비밀번호 확인 입력이 비밀번호 입력과 동일 여부 확인
    var passwordIsConfirmed: Bool {
        return password == passwordConfirm || passwordConfirm.isEmpty
    }

    var submitAvailable: Bool {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty else {
            return false
        }
        return isValidEmail && isValidPassword && passwordIsConfirmed
    }

    /// 각각의 TextField별 setter
    /// - Parameters:
    ///   - inputType: TextField 종류
    ///   - newValue: 새로운 값
    func update(_ inputType: InputType, newValue: String) {
        switch inputType {
        case .name:
            name = newValue
        case .email:
            email = newValue
        case .password:
            password = newValue
        case .passwordConfirm:
            passwordConfirm = newValue
        }
    }

    /// TextField에 대한 ViewModel 빌드
    /// - Parameter inputType: TextField 종류
    func createUnderlineViewModel(inputType: InputType) -> UnderlineTextFieldViewModel {
        switch inputType {
        case .name:
            return UnderlineTextFieldViewModel(descLabelStr: "이름",
                                               inputContentType: .name,
                                               returnKeyType: .continue)
        case .email:
            let emailViewModel = UnderlineTextFieldViewModel(descLabelStr: "이메일",
                                                             inputContentType: .emailAddress,
                                                             returnKeyType: .continue,
                                                             keyboardType: .asciiCapable)
            emailViewModel.validCondition = { [weak self] input in
                self?.isValidEmail ?? false
            }
            emailViewModel.assistantStr = invalidMessage(inputType: inputType)
            return emailViewModel
        case .password:
            let passwordViewModel = UnderlineTextFieldViewModel(descLabelStr: "비밀번호",
                                                                inputContentType: .password,
                                                                returnKeyType: .continue)
            passwordViewModel.validCondition = { [weak self] _ in
                self?.isValidPassword ?? false
            }
            passwordViewModel.assistantStr = invalidMessage(inputType: inputType)
            return passwordViewModel
        case .passwordConfirm:
            let passwordConfirmViewModel = UnderlineTextFieldViewModel(descLabelStr: "비밀번호 확인",
                                                                       inputContentType: .password,
                                                                       returnKeyType: .done)
            passwordConfirmViewModel.validCondition = { [weak self] _ in
                self?.passwordIsConfirmed ?? false
            }
            passwordConfirmViewModel.assistantStr = invalidMessage(inputType: inputType)
            return passwordConfirmViewModel
        }
    }

    /// 각각의 TextField별 에러 메시지
    /// - Parameter inputType: TextField 종류
    func invalidMessage(inputType: InputType) -> String {
        switch inputType {
        case .name:
            return ""
        case .email:
            return "유효하지 않은 이메일 형식입니다."
        case .password:
            return "6-12자로 입력해주세요."
        case .passwordConfirm:
            return "비밀번호가 일치하지 않습니다."
        }
    }

    func signUp(completionHandler: @escaping (Result<Void, Error>) -> Void) {

        let body = [
            "email": email,
            "password": password,
            "name": name
        ]

        let request = URLRequest(target: MemberTarget.signUp(body))

        let future = Future<HasAuthToken, Error> { [weak self] promise in
            guard let self = self else { return }
            AuthProvider.issueToken(email: self.email, password: self.password) { (result) in
                promise(result)
            }
        }

        let completion: (Subscribers.Completion<URLError>) -> Void = { completion in
            if case .failure(let error) = completion {
                print("[SignUp][요청] 실패: \(error)")
                completionHandler(.failure(error))
            }
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .compactMap { _ in future }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completion, receiveValue: { [weak self] (future) in
                guard let self = self else { return }
                future.sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("[SignUp][Token] 발행 실패: \(error)")
                        completionHandler(.failure(error))
                    }
                }, receiveValue: { token in
                    let member = Member(name: self.name, email: self.email, password: self.password)

                    MemberAccess.default.update(identity: member)
                    MemberAccess.default.update(token: token)
                    completionHandler(.success(()))
                }).store(in: &self.cancelables)
            }).store(in: &cancelables)
    }
}
