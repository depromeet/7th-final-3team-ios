//
//  MemberMeta.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct MemberMeta: Decodable {
    let isManager: Bool
    let group: [WNGroup]

    enum CodingKeys: String, CodingKey {
        case isManager = "manager"
        case group
    }
}
