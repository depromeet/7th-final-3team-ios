//
//  CreateGroupViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/31.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Combine

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

    }

}
