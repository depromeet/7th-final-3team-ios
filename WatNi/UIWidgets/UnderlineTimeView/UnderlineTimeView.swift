//
//  UnderlineTimeView.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/06.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class UnderlineTimeView: UIView {

    @IBOutlet private weak var fromTimeLabel: UILabel!
    @IBOutlet private weak var toTimeLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
