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
        return true
    }

    func update(input: String) {
        inputText = input
    }

    func createUnderlineViewModel() -> UnderlineTextFieldViewModel {
        // TODO: 초대코드 Validation 룰 반영
        return UnderlineTextFieldViewModel(descLabelStr: "")
    }

    func submitAction(completionHandler: @escaping (Result<Decodable, Error>) -> Void) {

    }

}
