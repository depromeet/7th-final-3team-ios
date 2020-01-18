//
//  Font+Custom.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/18.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    enum SpoqaFont: String {
        case thin = "Spoqa Han Sans Thin"
        case light = "Spoqa Han Sans Light"
        case regular = "Spoqa Han Sans Regular"
        case bold = "Spoqa Han Sans Bold"
    }

    /// 스포카 폰트에 대한 UIFont 인스턴스
    ///
    /// - Parameters:
    ///   - size: 폰트 사이즈
    ///   - weight: 폰트 굵기(light, bold, thin, regular 만 지원한다. 이외 폰트 굵기 설정시 regular로 설정된다.)
    static func spoqaFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        var font: UIFont?

        switch weight {
        case .light:
            font = UIFont(name: SpoqaFont.light.rawValue, size: size)
        case .bold:
            font = UIFont(name: SpoqaFont.bold.rawValue, size: size)
        case .thin:
            font = UIFont(name: SpoqaFont.thin.rawValue, size: size)
        default:
            font = UIFont(name: SpoqaFont.regular.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        }

        return font ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
}
