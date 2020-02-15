//
//  CreateGroupViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/31.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Combine
import SwiftyJSON

/// 모임 초대코드 생성 ViewModel
class CreateGroupCodeViewModel: NewbieViewModelProtocol {
    let group: WNGroup
    private var inputText: String = ""
    private var cancelables = Set<AnyCancellable>()

    init(group: WNGroup) {
        self.group = group
    }

    var titleGuideText: String {
        return "초대코드를\n생성해주세요."
    }

    var submitAvailable: Bool {
        return inviteCodeIsValid()
    }

    private func inviteCodeIsValid() -> Bool {
        let charactersets: [CharacterSet] = [.alphanumerics, .decimalDigits, .koreans]
        let allowedCharSet: CharacterSet = charactersets.formUnions()
        return inputText.unicodeScalars.allSatisfy { allowedCharSet.contains($0) }
    }

    func update(input: String) {
        inputText = input
    }

    func createUnderlineViewModel() -> UnderlineTextFieldViewModel {
        let textFieldViewModel = UnderlineTextFieldViewModel(descLabelStr: "")

        textFieldViewModel.validCondition = { [weak self] input in
            self?.inviteCodeIsValid() ?? false
        }
        textFieldViewModel.assistantStr = "초대코드는 12자리 이하로 한글, 영문, 숫자만 사용 가능합니다."
        return textFieldViewModel
    }

    func submitAction(completionHandler: @escaping (Result<Decodable, Error>) -> Void) {
        let body = [
            "applyType": "CODE",
            "content": inputText
        ]

        let request = URLRequest(target: GroupTarget.createInviteCode(body, groupId: group.groupId))

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { data, _ in
                try JSON(data: data, options: .allowFragments)
        }.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("[Group][초대 코드 생성] 실패: \(error)")
                completionHandler(.failure(error))
            }
        }, receiveValue: { json in
            print("[Group][초대 코드 생성] 성공: \(json["code"].stringValue)")

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
