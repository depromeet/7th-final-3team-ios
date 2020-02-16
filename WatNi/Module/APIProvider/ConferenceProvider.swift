//
//  ConferenceProvider.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

struct WNConferenceRequest: Encodable {
    let name: String
    let description: String
    let locationInfo: String
    let startAt: Int
    let endAt: Int
    let base64Image: String?
    let notice: String?
}

class ConferenceProvider {

    static let provider = MoyaProvider<ConferenceTarget>()

    static func createConference(groupId: Int, requestBody: WNConferenceRequest, completion: @escaping (Result<WNConference, Error>) -> Void) {

        provider.request(.createConference(requestBody, groupId: groupId)) { (result) in
            switch result {
            case .success(let response):
                guard (200...399).contains(response.statusCode) else {
                    completion(.failure(WNError.invalidStatusCode(response: response)))
                    return
                }
                do {
                    let conference = try JSONDecoder().decode(WNConference.self, from: response.data)
                    completion(.success(conference))
                } catch {
                    print("[Conference][생성][실패] Error: \(error)")
                    completion(.failure(error))
                }

            case .failure(let error):
                print("[Conference][생성][실패] Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    static func updateConference(groupId: Int, conferenceId: Int, requestBody: WNConferenceRequest,
                                 completion: @escaping (Result<(photoURLStr: String?, notice: String?), Error>) -> Void) {

        provider.request(.updateConference(requestBody, groupId: groupId, conferenceId: conferenceId)) { (result) in
            switch result {
            case .success(let response):
                guard (200...399).contains(response.statusCode) else {
                    completion(.failure(WNError.invalidStatusCode(response: response)))
                    return
                }
                do {
                    let json = try JSON(data: response.data)

                    let photoURL = json["photoUrl"].string
                    let notice = json["notice"].string

                    completion(.success((photoURL, notice)))
                } catch {
                    print("[Conference][갱신][실패] Error: \(error)")
                    completion(.failure(error))
                }

            case .failure(let error):
                print("[Conference][갱신][실패] Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
