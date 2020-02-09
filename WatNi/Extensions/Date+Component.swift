//
//  Date+Component.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/09.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

extension Date {
    func component(of component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
}
