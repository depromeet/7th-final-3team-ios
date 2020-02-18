//
//  UserCodeViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/31.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import SwiftyJSON
import Combine

class UserCodeViewModel: NewbieViewModelProtocol {
    private var inputText: String = ""
    private var cancelables = Set<AnyCancellable>()

    var titleGuideText: String {
        return "초대코드를\n입력해주세요."
    }

    var submitAvailable: Bool {
        return true
    }

    func update(input: String) {
        inputText = input
    }

    /// TextField에 대한 ViewModel 빌드
    ///
    /// - Parameter inputType: TextField 종류
    func createUnderlineViewModel() -> UnderlineTextFieldViewModel {
        return UnderlineTextFieldViewModel(descLabelStr: "")
    }

    func submitAction(completionHandler: @escaping (Result<Decodable, Error>) -> Void) {

        let body: [String: String] = [
            "code": inputText
        ]

        let request = URLRequest(target: GroupTarget.applyGroup(body))

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> JSON in

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw SwiftyJSONError.invalidJSON
                }

                guard (200...399).contains(httpResponse.statusCode) else {
                    let json = try? JSON(data: data)
                    let message = json?["error_description"].stringValue ?? ""
                    throw WNError.responseFailed(message: message)
                }
                return try JSON(data: data)
            }.eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("[Group][모임 참여] 실패: \(error)")
                    completionHandler(.failure(error))
                }
            }, receiveValue: { json in
                print("[Group][모임 참여] 성공: \(json["code"].stringValue)")

                MemberProvider.memberMeta { (result) in
                    switch result {
                    case .failure(let error):
                        completionHandler(.failure(error))
                    case .success(let memberMeta):
                        MemberAccess.default.update(memberMeta: memberMeta)
                        completionHandler(.success(memberMeta.groups))
                    }
                }
            }).store(in: &cancelables)
    }
}
