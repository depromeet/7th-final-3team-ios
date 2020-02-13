//
//  MemberMeta.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct MemberMeta {
    private(set) var memberIdentity: MemberIdentity
    let isManager: Bool
    let group: [WNGroup]

    mutating func updateMember(_ memberIdentity: MemberIdentity) {
        self.memberIdentity = memberIdentity
    }
}
