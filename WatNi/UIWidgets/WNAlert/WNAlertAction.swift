//
//  WNAlertAction.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class WNAlertAction {
    let title: String
    let handler: (() -> Void)?

    init(title: String, handler: (() -> Void)?) {
        self.title = title
        self.handler = handler
    }
}
