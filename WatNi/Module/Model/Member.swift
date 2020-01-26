//
//  Member.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/12.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

protocol MemeberIdentity {
    var name: String { get }
    var email: String { get }
    var password: String { get }
}

/// 왔니 서비스 사용자 정보 저장 모델
struct Member: Codable, MemeberIdentity {
    let name: String
    let email: String
    let password: String

    func save() {
        KeychainProvider.default.update(name, for: .name)
        KeychainProvider.default.update(email, for: .email)
        KeychainProvider.default.update(password, for: .password)

        print("[Member][keychain] 저장 name: \(name), email: \(email), pw: \(password)")
    }
}

// MARK: KeychainDecodable
extension Member: KeychainDecodable {
    static var fromKeychain: Member {
        let name = KeychainProvider.default.item(for: .name) ?? ""
        let email = KeychainProvider.default.item(for: .email) ?? ""
        let password = KeychainProvider.default.item(for: .password) ?? ""

        return Member(name: name, email: email, password: password)
    }
}

extension Member: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Member - [name: \(name),\nemail: \(email),\n password: \(password)]"
    }
}
