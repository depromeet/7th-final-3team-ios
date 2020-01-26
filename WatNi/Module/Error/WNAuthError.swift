//
//  WNAuthError.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/26.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

enum WNAuthError: Error {
    case tokenNotExist
    case tokenExpired
}
