//
//  AuthTarget.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

/// 인증 API Target
enum AuthTarget: TargetType {

    /// token 최초 발급
    case issueToken(Encodable)
    /// token 갱신
    case refreshToken(Encodable)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .issueToken, .refreshToken:
            return "oauth/token"
        }
    }

    var method: Moya.Method {
        switch self {
        case .issueToken, .refreshToken:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .issueToken(let body),
             .refreshToken(let body):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

// MARK: AccessTokenAuthorizable
extension AuthTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        return .basic
    }
}
