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
    var token: Token { get }
}

/// 왔니 서비스 사용자 정보 저장 모델
struct Member: Codable, MemeberIdentity {
    let name: String
    let email: String
    let password: String
    let token: Token
}
