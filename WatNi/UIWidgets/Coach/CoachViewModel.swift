//
//  CoachViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/26.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class CoachViewModel {

    var memberInfo: String {
        guard let member = MemberAccess.default.member else {
            return "멤버 정보 없음"
        }
        return "현재 접속한 사용자 정보\n\(member.debugDescription)"
    }
}
