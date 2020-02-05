//
//  NoticeInputView.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/06.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class NoticeInputView: UIView {
    @IBOutlet private weak var textView: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 27.2
        paragraphStyle.maximumLineHeight = 27.2
        paragraphStyle.lineBreakMode = .byWordWrapping
        textView.typingAttributes = [.font: UIFont.spoqaFont(ofSize: 17, weight: .regular),
                                     .paragraphStyle: paragraphStyle]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
