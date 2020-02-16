//
//  Date+Extensions.swift
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

    /// Date를 String으로 변환
    /// - Parameter format: 변환 Format
    /// - Parameter locale: DateFormatter의 Locale(default: "ko_KR")
    func toString(format: String, locale: Locale = Locale(identifier: "ko_KR")) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
}
