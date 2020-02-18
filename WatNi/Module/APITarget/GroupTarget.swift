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
    /// 모임 참여
    case applyGroup(Encodable)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .createGroup:
            return "api/group"
        case .createInviteCode(_, let groupId):
            return "api/group/\(groupId)/apply-way"
        case .applyGroup:
            return "api/group/accession"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createGroup, .createInviteCode, .applyGroup:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .createGroup(let body), .applyGroup(let body):
            return .requestJSONEncodable(body)
        case .createInviteCode(let body, _):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createGroup, .createInviteCode, .applyGroup:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        }
    }
}
