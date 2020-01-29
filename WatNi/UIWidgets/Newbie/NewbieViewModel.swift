//
//  NewbieViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/30.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class NewbieViewModel {

    enum ViewType {
        /// 모임 이름 입력
        case createGroup
        /// 초대 코드 생성
        case createCode
        /// 초대 코드 입력
        case putCode
    }

    let viewType: ViewType

    private var inputText: String = ""

    init(viewType: ViewType) {
        self.viewType = viewType
    }

    var titleGuideText: String {
        switch viewType {
        case .createGroup:
            return "모임 이름을\n입력해주세요."
        case .createCode:
            return "초대코드를\n생성해주세요."
        case .putCode:
            return "초대코드를\n입력해주세요."
        }
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
        switch viewType {
        case .createGroup:
            // TODO: 모임 이름 Validation 룰 반영
            return UnderlineTextFieldViewModel(descLabelStr: "")
        case .createCode:
            // TODO: 초대코드 Validation 룰 반영
            return UnderlineTextFieldViewModel(descLabelStr: "")
        case .putCode:
            return UnderlineTextFieldViewModel(descLabelStr: "")
        }
    }
}
