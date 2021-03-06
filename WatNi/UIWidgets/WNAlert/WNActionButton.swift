//
//  WNActionButton.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class WNActionButton: UIButton {

    var didTapButton: ((_ sender: UIButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setTitleColor(WNColor.black87, for: .normal)
        self.titleLabel?.font = UIFont.spoqaFont(ofSize: 18, weight: .regular)

        self.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func btnTapped(_ sender: UIButton) {
        didTapButton?(sender)
    }
}
