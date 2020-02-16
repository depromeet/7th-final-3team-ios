//
//  TextUtil.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

struct TextUtil {

    private static let dummyLabel = UILabel(frame: .zero)

    private static func resetDummyLabel() {
        dummyLabel.numberOfLines = 1
        dummyLabel.text = nil
        dummyLabel.attributedText = nil
        dummyLabel.font = nil
    }
}

extension TextUtil {

    static func contentsSize(_ text: String, font: UIFont) -> CGSize {
        resetDummyLabel()
        dummyLabel.text = text
        dummyLabel.font = font
        dummyLabel.sizeToFit()
        return dummyLabel.frame.size
    }

    static func contentsSize(_ attributedText: NSAttributedString) -> CGSize {
        resetDummyLabel()
        dummyLabel.attributedText = attributedText
        dummyLabel.sizeToFit()
        return dummyLabel.frame.size
    }

    static func contentsSize(_ text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        resetDummyLabel()
        dummyLabel.text = text
        dummyLabel.font = font
        dummyLabel.numberOfLines = 0
        return dummyLabel.sizeThatFits(maxSize)
    }

    static func contentsSize(_ attributedText: NSAttributedString, maxSize: CGSize) -> CGSize {
        resetDummyLabel()
        dummyLabel.attributedText = attributedText
        dummyLabel.numberOfLines = 0
        return dummyLabel.sizeThatFits(maxSize)
    }

    static func contentsHeight(_ text: String, font: UIFont, maxSize: CGSize) -> CGFloat {
        return ceil(contentsSize(text, font: font, maxSize: maxSize).height)
    }

    static func contentsHeight(_ attributedText: NSAttributedString, maxSize: CGSize) -> CGFloat {
        return ceil(contentsSize(attributedText, maxSize: maxSize).height)
    }

    static func lineCount(_ attributedText: NSAttributedString, maxSize: CGSize, lineHeight: CGFloat) -> Int {
        return Int(contentsSize(attributedText, maxSize: maxSize).height / lineHeight)
    }
}
