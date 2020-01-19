//
//  SubmitButton.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/19.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class SubmitButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    private func setupButton() {
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(WNColor.black5, for: .disabled)
        self.layer.cornerRadius = 4
        updateBackgroundColor()
    }

    private func updateBackgroundColor() {
        if isEnabled {
            layer.backgroundColor = WNColor.primaryRed.cgColor
        } else {
            layer.backgroundColor = WNColor.gray.cgColor
        }
    }
}
