//
//  MemberAccess.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/26.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

/// Member와 Token 정보 접근 관리자
class MemberAccess {

    static let `default` = MemberAccess()

    private(set) var member: Member?
    private(set) var token: Token?

    private init() {
        self.member = Member.fromKeychain
        self.token = Token.fromKeychain
    }

    func update(identity: MemeberIdentity) {
        self.member = Member(name: identity.name, email: identity.email, password: identity.password)
        self.member?.save()
    }

    func update(token: HasAuthToken) {
        self.token = Token(accessToken: token.accessToken, refreshToken: token.refreshToken,
                           type: token.type, expiresIn: token.expiresIn, scope: token.scope)
        self.token?.save()
    }
}
