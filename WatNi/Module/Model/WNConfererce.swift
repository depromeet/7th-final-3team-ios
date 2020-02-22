//
//  WNConfererce.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct WNConference: Decodable {
    let conferenceID: Int
    let name: String
    let description: String
    let location: String
    let startDate: TimeInterval
    let endDate: TimeInterval
    let attendances: [WNAttendance]?

    private(set) var photoURLStr: String?
    private(set) var notice: String?

    enum CodingKeys: String, CodingKey {
        case conferenceID = "conferenceId"
        case name
        case description
        case location = "locationInfo"
        case startDate = "startAt"
        case endDate = "endAt"
        case photoURLStr = "photoUrl"
        case notice
        case attendances
    }

    mutating func updatePhoto(urlStr: String?) {
        self.photoURLStr = urlStr
    }

    mutating func updateNotice(_ notice: String?) {
        self.notice = notice
    }
}

extension WNConference: Comparable {
    static func == (lhs: WNConference, rhs: WNConference) -> Bool {
        return lhs.conferenceID == rhs.conferenceID
    }

    static func < (lhs: WNConference, rhs: WNConference) -> Bool {
        guard lhs.startDate == rhs.startDate else {
            return lhs.startDate < rhs.startDate
        }
        return lhs.endDate < rhs.endDate
    }
}

extension Array where Element == WNConference {
    var future: [WNConference] {
        return filter {
            return Date().timeIntervalSince1970 < $0.endDate
        }
    }
}
