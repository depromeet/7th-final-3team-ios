//
//  SignInViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class SignInViewModel {

    enum InputType {
        case email, password
    }

    private var email: String = ""
    private var password: String = ""

    var textFieldIsEmpty: Bool {
        return email.isEmpty || password.isEmpty
    }

    /// 각각의 TextField별 setter
    /// - Parameters:
    ///   - inputType: TextField 종류
    ///   - newValue: 새로운 값
    func update(_ inputType: InputType, newValue: String) {
        switch inputType {
        case .email:
            email = newValue
        case .password:
            password = newValue
        }
    }

    func signIn(completionHandler: @escaping (Result<Void, Error>) -> Void) {

        AuthProvider.issueToken(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("[SignIn][요청] 실패: \(error)")
                completionHandler(.failure(error))
            case .success(let token):

                self?.memberMetaData { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    case .success(let memberMeta):
                        guard let self = self else { return }

                        let name = memberMeta.member.name
                        let newMember = Member(name: name, email: self.email, password: self.password)

                        memberMeta.updateMember(newMember)
                        MemberAccess.default.update(memberMeta: memberMeta)
                        MemberAccess.default.update(token: token)

                        completionHandler(.success(()))
                    }
                }
            }
        }
    }

    func memberMetaData(completionHandler: @escaping (Result<MemberMeta, Error>) -> Void) {
        MemberProvider.memberMeta { (result) in
            switch result {
            case .success(let memberMeta):
                print("[User][조회] \(memberMeta)")
                completionHandler(.success(memberMeta))
            case .failure(let error):
                print("[User][조회] 실패: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
}
