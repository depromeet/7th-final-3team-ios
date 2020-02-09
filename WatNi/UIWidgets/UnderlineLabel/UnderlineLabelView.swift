//
//  UnderlineLabelView.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/05.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class UnderlineLabelView: UIView {
    @IBOutlet weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
