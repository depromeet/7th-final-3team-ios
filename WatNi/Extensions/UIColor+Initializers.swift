//
//  UIColor+Initializers.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    /// hex RGB to UIColor
    /// example) 0xAAAAAA
    ///
    /// - Parameters:
    ///   - rgb: rgb hex
    ///   - a: alpha (0 ~ 1.0)
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            decimalRed: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }

    convenience init(decimalRed: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(decimalRed) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - Private
extension UIColor {
    private convenience init(red: Int, green: Int, blue: Int, hexAlpha: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(hexAlpha) / 255.0
        )
    }
}
