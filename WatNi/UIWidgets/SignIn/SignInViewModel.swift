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
                // TODO: 이름 처리
                let member = Member.fromKeychain
                let email = self?.email ?? ""
                let password = self?.password ?? ""
                MemberAccess.default.update(identity: Member(name: member.name, email: email, password: password))
                MemberAccess.default.update(token: token)

                completionHandler(.success(()))
            }
        }
    }
}
