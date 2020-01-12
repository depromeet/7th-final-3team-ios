//
//  APIConfig.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/12.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct APIConfig {

    static let clientID = "watni"
    static let clientSecret = "Nn5aDQTgw4Tn"
    static let baseURLStr = "http://ec2-52-78-36-242.ap-northeast-2.compute.amazonaws.com"
    static let baseURL = URL(string: baseURLStr) ?? FileManager.default.temporaryDirectory

    /// 클라이언트 인증 API Key, oauth 인증 API 호출시 다음의 헤더를 추가한다.
    ///
    /// * Request Header
    /// ```
    /// Authorization : Basic <token>
    /// ```
    static var serviceToken: String {
        return "\(clientID):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
    }
}
