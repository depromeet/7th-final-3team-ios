//
//  Array+CharacterSets.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/01.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

extension Array where Element == CharacterSet {
    func formUnions() -> CharacterSet {
        var characterSet = CharacterSet()
        forEach {
            characterSet.formUnion($0)
        }
        return characterSet
    }
}
