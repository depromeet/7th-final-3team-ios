//
//  NSObject+Properties.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    class var bundle: Bundle {
        return Bundle(for: self)
    }
}
