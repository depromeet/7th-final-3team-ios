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

    var photoURLStr: String?
    var notice: String?

    enum CodingKeys: String, CodingKey {
        case conferenceID = "conferenceId"
        case name
        case description
        case location = "locationInfo"
        case startDate = "startAt"
        case endDate = "endAt"
        case photoURLStr = "photoUrl"
        case notice
    }
}