//
//  MemberProvider.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

class MemberProvider {

    /// Moya PlugIns
    static var plugins: [PluginType] {
        return [
            NetworkLoggerPlugin(verbose: true)
        ]
    }

    static let provider = MoyaProvider<MemberTarget>(plugins: plugins)

    static func signUp(email: String, password: String, name: String, completion: @escaping (Result<MemberIdentity, Error>) -> Void) {

        let body = [
            "email": email,
            "password": password,
            "name": name
        ]

        provider.request(.signUp(body)) { (result) in
            switch result {
            case .success(let response):

                guard (200...399).contains(response.statusCode) else {
                    completion(.failure(WNAuthError.invalidGrant))
                    return
                }

                let member = Member(name: name, email: email, password: password)
                completion(.success(member))
            case .failure(let error):
                print("[Member][가입][실패] Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
