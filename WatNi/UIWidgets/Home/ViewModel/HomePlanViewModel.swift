//
//  HomePlanViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import UIKit

enum HomePlanSectionType {
    case plan
}

class HomePlanViewModel: HomeTabViewModel, CollectionViewModelBase {

    typealias BaseModel = WNConference
    typealias SectionType = HomePlanSectionType
    typealias ModelCollection = [WNConference]
    typealias CellModel = Array<CollectionViewCellModel>.Element
    typealias ReusableViewModel = CollectionViewReusableViewModel

    let userGroups: [WNGroup]
    var models: [WNConference]
    var cellModels: [CollectionViewCellModel] = []
    var reusableViewModels: [CollectionViewReusableViewModel] = []

    let tabTitle = "일정"

    init(groups: [WNGroup]) {
        self.userGroups = groups

        let userConferences: [WNConference] = groups.first?.conferences ?? []

        self.models = userConferences

        cellModels = userConferences.map { conference in
            return HomePlanCollectionViewCellModel(conference: conference)
        }
        reusableViewModels = [HomePlanCollectionHeaderViewModel()]
    }

    var shouldHideCollectionView: Bool {
        let groups = MemberAccess.default.memberMeta?.groups ?? []

        guard let conferences = groups.first?.conferences else {
            return false
        }
        return conferences.isEmpty
    }

    var shouldHideManagerEmptyView: Bool {
        let isManager = MemberAccess.default.memberMeta?.isManager ?? false
        guard isManager else {
            return true
        }
        return !shouldHideCollectionView
    }

    var shouldHideParticipantEmptyView: Bool {
        let isManager = MemberAccess.default.memberMeta?.isManager ?? false
        guard !isManager else {
            return true
        }
        return !shouldHideCollectionView
    }
}

extension HomePlanViewModel: HasCellModel {
    func cellModel(indexPath: IndexPath) -> CollectionViewCellModel? {
        return cellModels[safe: indexPath.row]
    }
}

extension HomePlanViewModel: HasReusableViewModel {
    func reusableViewModel(sectionType: HomePlanSectionType) -> CollectionViewReusableViewModel? {
        return reusableViewModels.first
    }
}

extension HomePlanViewModel {
    var numberOfItems: Int {
        return cellModels.count
    }

    private func cellImageHeight(indexPath: IndexPath) -> CGFloat {

        guard let cellModel = cellModels[safe: indexPath.row] as? HomePlanCollectionViewCellModel else {
            return .zero
        }

        guard cellModel.conference?.photoURLStr != nil else {
            return .zero
        }

        return 227
    }

    private func cellNoticeHeight(indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        guard let cellModel = cellModels[safe: indexPath.row] as? HomePlanCollectionViewCellModel else {
            return .zero
        }

        guard let noticeText = cellModel.conference?.notice else {
            return .zero
        }

        let labelHeight = TextUtil.contentsHeight(noticeText,
                                                  font: UIFont.spoqaFont(ofSize: 24, weight: .regular),
                                                  maxSize: CGSize(width: cellWidth,
                                                                  height: CGFloat.greatestFiniteMagnitude))
        return labelHeight
    }

    func cellHeight(cellWidth: CGFloat, indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 161
        let imageHeight = cellImageHeight(indexPath: indexPath)
        let noticeHeight = cellNoticeHeight(indexPath: indexPath, cellWidth: cellWidth)

        return defaultHeight + imageHeight + noticeHeight 
    }
}
