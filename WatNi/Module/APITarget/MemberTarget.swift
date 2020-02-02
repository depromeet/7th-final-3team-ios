//
//  MemberTarget.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/22.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

enum MemberTarget: TargetType {

    /// 회원 가입
    case signUp(Encodable)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .signUp:
            return "sign-up"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .signUp(let body):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
