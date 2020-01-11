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

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""

    private var disposable = Set<AnyCancellable>()

    init() {
        $email.sink {
            print("email", $0)
        }.store(in: &disposable)

        $password.sink {
            print("password", $0)
        }.store(in: &disposable)

        $passwordConfirm.sink {
            print("confirm", $0)
        }.store(in: &disposable)
    }

    /// Validate Email
    /// - Parameter candidate: Email String
    var isValidEmail: Bool {
        let expression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = email.range(of: expression, options: .regularExpression)

        return result != nil
    }

    /// Validate Password
    /// - Parameter candidate: Password String
    var isValidPassword: Bool {
        return password.count >= 6 && password.count <= 12
    }
}
