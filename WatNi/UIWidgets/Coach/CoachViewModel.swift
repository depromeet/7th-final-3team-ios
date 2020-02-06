//
//  CoachViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/26.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class CoachViewModel {
    var memberMeta: [MemberMeta]

    init(memberMeta: [MemberMeta] = []) {
        self.memberMeta = memberMeta
    }

    var memberNameStr: String {
        guard let member = MemberAccess.default.member else {
            return "익명님!\n반갑습니다."
        }
        return "\(member.name)님!\n반갑습니다."
    }
}
