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
    /// 회원의 그룹 정보 조회
    case memberMeta

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .signUp:
            return "sign-up"
        case .memberMeta:
            return "api/user/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .memberMeta:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .signUp(let body):
            return .requestJSONEncodable(body)
        case .memberMeta:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signUp:
            return ["Content-Type": "application/json"]
        case .memberMeta:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        }
    }
}
