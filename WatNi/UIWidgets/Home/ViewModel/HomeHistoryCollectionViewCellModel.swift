//
//  HomeHistoryCollectionViewCellModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/19.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct HomeHistoryCollectionViewCellModel: CollectionViewCellModel {
    var cellType: BindableCollectionViewCell.Type {
        return HomeHistoryAttendanceCollectionViewCell.self
    }

    let attendance: WNAttendance?

    init(attendance: WNAttendance? = nil) {
        self.attendance = attendance
    }
}
