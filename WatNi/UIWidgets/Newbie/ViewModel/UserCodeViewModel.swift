//
//  UserCodeViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/31.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class UserCodeViewModel: NewbieViewModelProtocol {
    private var inputText: String = ""

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
        // TODO: 초대코드 입력 API 처리
    }
}
