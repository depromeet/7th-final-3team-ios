//
//  UIView+Nib.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import UIKit

extension UIView {

    class var nib: UINib {
        return UINib(nibName: self.className, bundle: self.bundle)
    }

    func loadNib() {
        let bundle = type(of: self).bundle
        let nibName = type(of: self).className
        guard let nibs = bundle.loadNibNamed(nibName, owner: self, options: nil) else { return }
        guard let nib = nibs.first as? UIView else { return }

        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nib)
    }

}
