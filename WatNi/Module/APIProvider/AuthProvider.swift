//
//  AuthProvider.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

/// 인증 API 호출 Provider
class AuthProvider {

    /// Moya PlugIns
    static var plugins: [PluginType] {
        return [
            NetworkLoggerPlugin(verbose: true),
            AccessTokenPlugin { APIConfig.serviceToken }
        ]
    }

    static let provider = MoyaProvider<AuthTarget>(plugins: plugins)

    static func issueToken(email: String, password: String, completion: @escaping (Result<HasAuthToken, Error>) -> Void) {
        let body: [String: String] = [
            "grant_type": "password",
            "username": email,
            "password": password
        ]

        provider.request(.issueToken(body)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let token = try response.map(Token.self)
                    completion(.success(token))
                } catch {
                    print("[Token][발급][성공] Map Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[Token][발급][실패] Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    static func refreshToken(refreshToken: String, completion: @escaping (Result<HasAuthToken, Error>) -> Void) {
        let body: [String: String] = [
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
        ]

        provider.request(.refreshToken(body)) { (result) in

            switch result {
            case .success(let response):
                do {
                    let token = try response.map(Token.self)
                    completion(.success(token))
                } catch {
                    print("[Token][갱신][성공] Map Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[Token][갱신][실패] Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
