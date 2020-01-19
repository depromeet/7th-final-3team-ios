//
//  UnderlineTextFieldViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

protocol UnderlineTextFieldViewModelProtocol {
    /// TextField 입력 문구
    var inputStr: String { get set }
    /// TextField Valid 여부
    var inputIsValid: Bool { get }
    /// TextField Valid 조건 설정
    var validCondition: ((_ inputString: String) -> Bool)? { get set }
    /// 상단 설명 문구
    var descLabelStr: String { get }
    /// TextField의 ContentType
    var inputContentType: UITextContentType { get }
    /// TextField의 ReturnKeyType
    var returnKeyType: UIReturnKeyType { get }
    /// TextField의 KeyboardType
    var keyboardType: UIKeyboardType { get }
    /// 하단 가이드 문구
    var assistantLabelStr: String { get }
    /// Input 값에 SecureText 사용 여부
    var isSecureTextEntry: Bool { get }
    /// FontSize: TextField
    var textFieldFontSize: CGFloat { get }
    /// LineHeight: TextField
    var textFieldLineHeight: CGFloat { get }
    /// FontSize: descLabel
    var descLabelFontSize: CGFloat { get }
    /// FontSize: assistantLabel
    var assistantLabelFontSize: CGFloat { get }
}

class UnderlineTextFieldViewModel: UnderlineTextFieldViewModelProtocol {
    let inputContentType: UITextContentType
    let returnKeyType: UIReturnKeyType
    let keyboardType: UIKeyboardType

    var inputStr: String = ""
    var assistantStr: String = ""

    var descLabelStr: String
    var textFieldFontSize: CGFloat = 17
    var textFieldLineHeight: CGFloat = 25
    var descLabelFontSize: CGFloat = 14
    var assistantLabelFontSize: CGFloat = 12
    var validCondition: ((_ inputString: String) -> Bool)?

    init() {
        self.descLabelStr = ""
        self.inputContentType = .emailAddress
        self.returnKeyType = .default
        self.keyboardType = .default
    }

    init(descLabelStr: String,
         inputContentType: UITextContentType = .emailAddress,
         returnKeyType: UIReturnKeyType = .default,
         keyboardType: UIKeyboardType = .default) {

        self.descLabelStr = descLabelStr
        self.inputContentType = inputContentType
        self.returnKeyType = returnKeyType
        self.keyboardType = keyboardType
    }

    var assistantLabelStr: String {
        if inputIsValid {
            return ""
        }
        return assistantStr
    }

    var isSecureTextEntry: Bool {
        return inputContentType == .password
    }

    var inputIsValid: Bool {
        return validCondition?(inputStr) ?? true
    }
}
