//
//  HasConferenceDate.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

protocol HasConferenceDate {
    var conferenceStartTimeInterval: TimeInterval { get }
    var conferenceIsToday: Bool { get }
    var dDay: Int { get }
}

extension HasConferenceDate {
    var conferenceIsToday: Bool {
        let startDate = Date(timeIntervalSince1970: conferenceStartTimeInterval)
        return Calendar.current.isDateInToday(startDate)
    }

    var dDay: Int {
        let startDate = Date(timeIntervalSince1970: conferenceStartTimeInterval)
        let date1 = Calendar.current.startOfDay(for: Date())
        let date2 = Calendar.current.startOfDay(for: startDate)

        return Calendar.current.dateComponents([.day], from: date1, to: date2).day ?? 0
    }
}
