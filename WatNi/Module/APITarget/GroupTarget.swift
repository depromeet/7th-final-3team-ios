//
//  GroupTarget.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/31.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

enum GroupTarget: TargetType {

    /// 모임 생성
    case createGroup(Encodable)
    /// 모임 초대코드 생성
    case createInviteCode(Encodable, groupId: Int)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .createGroup:
            return "api/group"
        case .createInviteCode(_, let groupId):
            return "api/group/\(groupId)/apply-way"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createGroup, .createInviteCode:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .createGroup(let body):
            return .requestJSONEncodable(body)
        case .createInviteCode(let body, _):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createGroup:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        case .createInviteCode:
            return ["Content-Type": "application/json;charset=UTF-8",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        }
    }
}
