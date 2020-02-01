//
//  CharacterSets+Korean.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/01.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

extension CharacterSet {
    static let koreans = CharacterSet(charactersIn: UnicodeScalar("\u{AC00}")...UnicodeScalar("\u{D7A3}"))
}
