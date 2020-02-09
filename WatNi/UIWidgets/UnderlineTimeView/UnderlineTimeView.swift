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

    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!

    var didTapFromLabel: (() -> Void)?
    var didTapToLabel: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func fromLabelTapped(_ sender: UITapGestureRecognizer) {
        didTapFromLabel?()
    }

    @IBAction func toLabelTapped(_ sender: UITapGestureRecognizer) {
        didTapToLabel?()
    }
}
