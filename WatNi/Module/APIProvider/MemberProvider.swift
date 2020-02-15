//
//  MemberProvider.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

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
                    completion(.failure(WNError.invalidStatusCode(response: response)))
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

    static func memberMeta(completion: @escaping (Result<MemberMeta, Error>) -> Void) {

        provider.request(.memberMeta) { (result) in
            switch result {
            case .success(let response):
                guard (200...399).contains(response.statusCode) else {
                    completion(.failure(WNError.invalidStatusCode(response: response)))
                    return
                }
                do {
                    let json = try JSON(data: response.data)
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue

                    let decoder = JSONDecoder()
                    let groupData = json["memberDetails"].arrayValue

                    let managers: [Int: Bool] = groupData.reduce(into: [Int: Bool]()) { (dict, data) in
                        guard let groupId = data["group"]["groupId"].int else { return }
                        let isManager = data["manager"].boolValue
                        dict[groupId] = isManager
                    }

                    let groups: [WNGroup] = try groupData.compactMap { data in
                        let itemData = try data["group"].rawData()
                        return try? decoder.decode(WNGroup.self, from: itemData)
                    }
                    let member = Member(name: name, email: email, password: "")
                    let memberMeta = MemberMeta(member: member, managers: managers, groups: groups)
                    completion(.success(memberMeta))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                print("[Member][ME][실패] Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
