//
//  HomePlanViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class HomePlanViewModel: HomeTabViewModel {
    let groups: [WNGroup]
    let tabTitle = "일정"

    init(groups: [WNGroup]) {
        self.groups = groups
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
