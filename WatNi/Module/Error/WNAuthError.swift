//
//  WNAuthError.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/26.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

enum WNAuthError: Error {
    case tokenNotExist
    case tokenExpired
    case invalidGrant

    var message: String {
        switch self {
        case .tokenNotExist:
            return "토큰이 존재하지 않습니다."
        case .tokenExpired:
            return "유효한 토큰이 존재하지 않습니다."
        case .invalidGrant:
            return "아이디 혹은 비밀번호가 잘못되었습니다."
        }
    }
}

extension Error {
    var userMessage: String {
        return (self as? WNAuthError)?.message ?? self.localizedDescription
    }
}
