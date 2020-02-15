//
//  Error+UserMessage.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

extension Error {
    var userMessage: String {
        return (self as? WNError)?.userMessage ?? self.localizedDescription
    }
}
