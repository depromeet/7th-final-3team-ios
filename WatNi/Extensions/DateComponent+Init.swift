//
//  DateComponent+Init.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

extension DateComponents {
    init(date: Date, time: Date) {
        self.init()

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)

        year = dateComponents.year
        month = dateComponents.month
        day = dateComponents.day

        hour = timeComponents.hour
        minute = timeComponents.minute
        second = timeComponents.second
    }
}
