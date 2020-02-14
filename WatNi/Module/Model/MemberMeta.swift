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
    let managers: [Int: Bool]
    let groups: [WNGroup]

    init(member: Member, managers: [Int: Bool] = [:], groups: [WNGroup] = []) {
        self.member = member
        self.managers = managers
        self.groups = groups
    }

    func updateMember(_ member: Member) {
        self.member = member
    }

    var isManager: Bool {
        guard managers.isEmpty == false else {
            return false
        }

        guard let currentGroupId = groups.first?.groupId else {
            return false
        }

        return managers[currentGroupId] ?? false
    }
}
