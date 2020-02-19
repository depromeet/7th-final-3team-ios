//
//  AttendanceTarget.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

enum AttendanceTarget: TargetType {
    case createAttendance(Encodable, groupId: Int, conferenceId: Int)
    /// 컨퍼런스별 참가자 정보
    case searchAttendances(groupId: Int, conferenceId: Int)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .createAttendance(_, let groupId, let conferenceId):
            return "api/group/\(groupId)/conference/\(conferenceId)/attendance"
        case .searchAttendances(let groupId, let conferenceId):
            return "api/group/\(groupId)/conference/\(conferenceId)/attendances"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createAttendance:
            return .post
        case .searchAttendances:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .createAttendance(let body, _, _):
            return .requestJSONEncodable(body)
        case .searchAttendances:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createAttendance, .searchAttendances:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        }
    }
}
