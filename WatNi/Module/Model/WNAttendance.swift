//
//  WNAttendance.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct WNAttendance: Decodable {
    let attendanceId: Int
    let attendanceStatus: String
    let attendanceAt: Int?
    let name: String?
    let attendanceType: String
    let imageUrl: String?
}

extension WNAttendance {
    enum PresentCondition {
        case participant
        case nonParticipant
    }

    var presentCondition: PresentCondition {
        switch attendanceStatus {
        case "ACCEPT":
            return .participant
        case "NOT_PARTICIPATING":
            return .nonParticipant
        default:
            return .nonParticipant
        }
    }
}
