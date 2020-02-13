//
//  MemberManager.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/13.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class MemberManager {
    static let shared = MemberManager()

    private(set) var memberMeta: MemberMeta?

    private init() { }

    func update(memberMeta: MemberMeta) {
        self.memberMeta = memberMeta
    }
}
