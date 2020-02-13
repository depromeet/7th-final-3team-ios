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
    let groups: [WNGroup]

    init(member: Member, isManager: Bool = false, groups: [WNGroup] = []) {
        self.member = member
        self.isManager = isManager
        self.groups = groups
    }

    func updateMember(_ member: Member) {
        self.member = member
    }
}
