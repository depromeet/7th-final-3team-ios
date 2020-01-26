//
//  Token.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/12.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

protocol HasAuthToken {
    var accessToken: String { get }
    var refreshToken: String { get }
    var type: String? { get set }
    var expiresIn: Int? { get set }
    var scope: String? { get set }
}

struct Token: Codable, HasAuthToken {
    let accessToken: String
    let refreshToken: String
    var type: String?
    var expiresIn: Int?
    var scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case type = "token_type"
        case scope
    }

    func save() {
        KeychainProvider.default.update(accessToken, for: .accessToken)
        KeychainProvider.default.update(refreshToken, for: .refreshToken)

        print("[Token][keychain] 저장 accToken: \(accessToken), refToken: \(refreshToken)")
    }
}

// MARK: KeychainDecodable
extension Token: KeychainDecodable {
    static var fromKeychain: Token {
        let accessToken = KeychainProvider.default.item(for: .accessToken) ?? ""
        let refreshToken = KeychainProvider.default.item(for: .refreshToken) ?? ""

        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
}
