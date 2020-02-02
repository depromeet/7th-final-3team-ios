//
//  Moya+URLRequest.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

extension URLRequest {

    /// Moya의 TargetType을 통해 URLRequest 생성
    init(target: TargetType) {
        let endpointURL = target.baseURL.appendingPathComponent(target.path)
        self.init(url: endpointURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

        httpMethod = target.method.rawValue
        target.headers?.forEach {
            self.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        guard target.method == .post else {
            return
        }

        switch target.task {
        case .requestJSONEncodable(let encodable):
            self.httpBody = encode(encodable: encodable)
        default:
            break
        }
    }

    private func encode(encodable: Encodable) -> Data? {
        do {
            let encodable = AnyEncodable(encodable)
            let encoder = JSONEncoder()
            let data = try encoder.encode(encodable)
            return data
        } catch {
            print(error)
        }
        return nil
    }

    struct AnyEncodable: Encodable {

        private let encodable: Encodable

        public init(_ encodable: Encodable) {
            self.encodable = encodable
        }

        func encode(to encoder: Encoder) throws {
            try encodable.encode(to: encoder)
        }
    }
}
