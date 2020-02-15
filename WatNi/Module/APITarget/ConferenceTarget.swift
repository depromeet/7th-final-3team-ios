//
//  ConferenceTarget.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

enum ConferenceTarget: TargetType {

    /// 일정 생성
    case createConference(Encodable, groupId: Int)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .createConference(_, let groupId):
            return "api/group/\(groupId)/conference"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createConference:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .createConference(let body, _):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createConference:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        }
    }
}
