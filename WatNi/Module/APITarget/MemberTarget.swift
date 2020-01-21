//
//  MemberTarget.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/22.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

enum MemberTarget: TargetType {

    /// 회원 가입
    case signUp(Encodable)

    var baseURL: URL {
        return APIConfig.baseURL
    }

    var path: String {
        switch self {
        case .signUp:
            return "sign-up"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Moya.Task {
        switch self {
        case .signUp(let body):
            return .requestJSONEncodable(body)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

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
