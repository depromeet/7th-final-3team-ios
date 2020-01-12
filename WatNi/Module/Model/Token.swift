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
    var type: String { get }
    var expiresIn: Int { get }
    var scope: String { get }
}

struct Token: Codable, HasAuthToken {
    let accessToken: String
    let refreshToken: String
    let type: String
    let expiresIn: Int
    let scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case type = "token_type"
        case scope
    }
}
