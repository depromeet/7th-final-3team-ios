//
//  SideMenuViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/21.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class SideMenuViewModel {

    var isManager: Bool {
        return  MemberAccess.default.memberMeta?.isManager ?? false
    }

    var managerStr: String {
        return isManager ? "관리자" : "회원"
    }

    var nameStr: String {
        return MemberAccess.default.memberMeta?.member.name ?? ""
    }

    var emailStr: String {
        return MemberAccess.default.memberMeta?.member.email ?? ""
    }
}
