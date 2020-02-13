//
//  MemberMeta.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class MemberMeta {
    private(set) var member: Member
    let isManager: Bool
    let group: [WNGroup]

    init(member: Member, isManager: Bool = false, group: [WNGroup] = []) {
        self.member = member
        self.isManager = isManager
        self.group = group
    }

    func updateMember(_ member: Member) {
        self.member = member
    }
}
