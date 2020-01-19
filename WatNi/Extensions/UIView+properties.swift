//
//  UIView+properties.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/19.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor {
        get {
            guard let borderColor = layer.borderColor else { return .clear }
            return UIColor(cgColor: borderColor)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

extension UIView {

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self

        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let parentViewController = parentResponder as? UIViewController {
                return parentViewController
            }
        }

        return nil
    }
}
