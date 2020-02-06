//
//  LaunchingTaskWorker.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Combine

class LaunchingTaskWorker {

    var cancelables = Set<AnyCancellable>()

    func userMetaData(completionHandler: @escaping (Result<[MemberMeta], Error>) -> Void) {

        let request = URLRequest(target: MemberTarget.memberMeta)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [MemberMeta].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("[User][조회] 실패: \(error)")
                    completionHandler(.failure(error))
                }
            }, receiveValue: { metaDatas in
                print("[User][조회] \(metaDatas)")
                completionHandler(.success(metaDatas))
            }).store(in: &cancelables)
    }
}
