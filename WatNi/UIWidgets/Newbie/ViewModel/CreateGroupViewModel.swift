//
//  CreateGroupViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/31.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Combine

/// 모임 생성 ViewModel
class CreateGroupViewModel: NewbieViewModelProtocol {
    private var inputText: String = ""
    private var cancelables = Set<AnyCancellable>()

    var titleGuideText: String {
        return "모임 이름을\n입력해주세요."
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
        // TODO: 모임 이름 Validation 룰 반영
        return UnderlineTextFieldViewModel(descLabelStr: "")
    }

    func submitAction(completionHandler: @escaping (Result<Decodable, Error>) -> Void) {
        let body = [
            "groupName": inputText,
            "description": ""
        ]
        let request = URLRequest(target: GroupTarget.createGroup(body))

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: WNGroup.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("[Group][생성] 실패: \(error)")
                    completionHandler(.failure(error))
                }
            }, receiveValue: { group in
                print("[Group][생성] \(group)")
                completionHandler(.success(group))
            }).store(in: &cancelables)
    }
}

struct WNGroup: Decodable {
    let groupId: Int
    let name: String
    let conferences: [String]
    let accessions: [String]
}
