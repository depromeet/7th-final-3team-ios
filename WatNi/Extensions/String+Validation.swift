//
//  String+Validation.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation

extension String {

    /// Validate Email
    /// - Parameter candidate: Email String
    func isValidEmail(candidate: String) -> Bool {
        let expression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = candidate.range(of: expression, options: .regularExpression)

        return result != nil
    }

    /// Validate Password
    /// - Parameter candidate: Password String
    func isValidPassword(candidate: String) -> Bool {
        return candidate.count >= 6 && candidate.count <= 12
    }
}
