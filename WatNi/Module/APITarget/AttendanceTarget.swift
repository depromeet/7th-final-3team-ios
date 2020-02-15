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

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .createAttendance(_, let groupId, let conferenceId):
            return "api/group/\(groupId)/conference/\(conferenceId)/attendance"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createAttendance:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .createAttendance(let body, _, _):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createAttendance:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(MemberAccess.headerToken)"]
        }
    }
}
