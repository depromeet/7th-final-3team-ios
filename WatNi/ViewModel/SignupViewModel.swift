//
//  SignupViewModel.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation

class SignupViewModel {

    var email: String = ""
    var password: String = ""

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
