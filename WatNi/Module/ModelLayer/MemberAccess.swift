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

    enum StorageKey {
        static let token = "com.depromeet.watni.token"
    }

    static let `default` = MemberAccess()

    private(set) var member: Member?
    private(set) var token: Token?

    private init() {
        self.member = Member.fromKeychain
        self.token = Token.fromKeychain
    }

    /// API header token
    static var headerToken: String {
        guard let accessToken = KeychainProvider.default.item(for: .accessToken) else {
            return ""
        }
        return accessToken
    }

    /// 사용자가 로그인되어 있는 상태인지 여부
    var isLogin: Bool {
        return UserDefaults.standard.bool(forKey: MemberAccess.StorageKey.token)
    }

    func update(identity: MemberIdentity) {
        self.member = Member(name: identity.name, email: identity.email, password: identity.password)
        self.member?.save()
    }

    func update(token: HasAuthToken) {
        self.token = Token(accessToken: token.accessToken, refreshToken: token.refreshToken,
                           type: token.type, expiresIn: token.expiresIn, scope: token.scope)
        self.token?.save()
        UserDefaults.standard.setValue(true, forKey: StorageKey.token)
    }

    func logout() {
        UserDefaults.standard.setValue(false, forKey: StorageKey.token)
        KeychainProvider.default.remove(key: .accessToken)
    }

    func refreshToken(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = KeychainProvider.default.item(for: .refreshToken) else {
            return
        }

        AuthProvider.refreshToken(refreshToken: refreshToken) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let token):
                MemberAccess.default.update(token: token)
                completionHandler(.success(()))
            }
        }
    }
}
