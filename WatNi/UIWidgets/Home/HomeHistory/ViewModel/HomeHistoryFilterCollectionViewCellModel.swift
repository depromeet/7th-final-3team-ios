//
//  HomeHistoryFilterCollectionViewCellModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct HomeHistoryFilterCollectionViewCellModel: CollectionViewCellModel {
    var cellType: BindableCollectionViewCell.Type {
        return HomeHistoryFilterCollectionViewCell.self
    }

    let totalCount: Int
    let conferenceStartTimeInterval: TimeInterval

    var didTapFilterView: (() -> Void)?

    init(totalCount: Int = 0, conference: WNConference? = nil) {
        self.totalCount = totalCount
        self.conferenceStartTimeInterval = conference?.startDate ?? Date().timeIntervalSince1970
    }

    var totalCountStr: String {
        return "회원 총 \(totalCount)명"
    }

    private var filterDateStr: String {
        let startDate = Date(timeIntervalSince1970: conferenceStartTimeInterval)
        let startDateStr = startDate.toString(format: "yy년 M월 dd일")
        return startDateStr
    }

    var filterViewStr: String {
        return "\(filterDateStr) / 전체"
    }
}
