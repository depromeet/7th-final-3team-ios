//
//  HomeHistoryViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import SwiftyJSON
import Combine

enum HomeHistorySectionType {
    case filter, attend
}

class HomeHistoryViewModel: HomeTabViewModel, CollectionViewModelBase {

    typealias BaseModel = WNAttendance
    typealias SectionType = HomeHistorySectionType
    typealias ModelCollection = [WNAttendance]
    typealias CellModel = Array<CollectionViewCellModel>.Element
    typealias ReusableViewModel = CollectionViewReusableViewModel

    let tabTitle = "출석 기록"

    var userGroups: [WNGroup]
    var models: [WNAttendance] = [] {
        didSet {

            cellModels = models.map { attendance in
                return HomeHistoryCollectionViewCellModel(attendance: attendance)
            }
            cellModels.insert(HomeHistoryFilterCollectionViewCellModel(), at: 0)
            reusableViewModels = [HomePlanCollectionHeaderViewModel()]
        }
    }
    var cellModels: [CollectionViewCellModel] = []
    var reusableViewModels: [CollectionViewReusableViewModel] = []

    private var cancelables = Set<AnyCancellable>()

    init(groups: [WNGroup]) {
        self.userGroups = groups
    }
}

extension HomeHistoryViewModel: HasCellModel {
    func cellModel(indexPath: IndexPath) -> CollectionViewCellModel? {
        return cellModels[safe: indexPath.row]
    }
}

extension HomeHistoryViewModel: HasReusableViewModel {
    func reusableViewModel(sectionType: HomeHistorySectionType) -> CollectionViewReusableViewModel? {
        return reusableViewModels.first
    }
}

extension HomeHistoryViewModel {
    var numberOfItems: Int {
        return cellModels.count
    }
}
