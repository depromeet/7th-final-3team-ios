//
//  HomeHistoryCollectionViewCellModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/19.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

struct HomeHistoryCollectionViewCellModel: CollectionViewCellModel {
    var cellType: BindableCollectionViewCell.Type {
        return HomeHistoryAttendanceCollectionViewCell.self
    }

    let attendance: WNAttendance?

    init(attendance: WNAttendance? = nil) {
        self.attendance = attendance
    }

    var name: String {
        return attendance?.name ?? ""
    }

    var photoURL: URL? {
        guard let photoURLStr = attendance?.imageUrl else { return nil }
        return URL(string: photoURLStr)
    }

    var presentCondition: WNAttendance.PresentCondition {
        return attendance?.presentCondition ?? .nonParticipant
    }

    var statusStr: String {
        switch presentCondition {
        case .participant:
            return "왔어요"
        case .nonParticipant:
            return "안 왔어요"
        }
    }

    var statusColor: UIColor {
        switch presentCondition {
        case .participant:
            return UIColor(decimalRed: 34, green: 34, blue: 34)
        case .nonParticipant:
            return UIColor(decimalRed: 34, green: 34, blue: 34, alpha: 0.3)
        }
    }
}
