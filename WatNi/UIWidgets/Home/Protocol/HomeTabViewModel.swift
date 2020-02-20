//
//  HomeTabViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

/// Home의 Tab별 ViewModel 공통 구현
protocol HomeTabViewModel {
    var userGroups: [WNGroup] { get }
    var tabTitle: String { get }
    var shouldHideCollectionView: Bool { get }
    var shouldHideManagerEmptyView: Bool { get }
    var shouldHideParticipantEmptyView: Bool { get }
}

extension HomeTabViewModel {
    var shouldHideCollectionView: Bool {
        guard let conferences = userGroups.first?.conferences else {
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
