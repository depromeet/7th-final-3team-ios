//
//  WNGroup.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct WNGroup: Decodable {
    let groupId: Int
    let name: String
    // TODO: WNConference 정의 이후 변경
    let conferences: [String]
}
