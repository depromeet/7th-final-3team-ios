//
//  HomeTabPagerViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

enum HomeTab: CaseIterable {
    case plan
    case history

    var viewControllerName: String {
        switch self {
        case .plan:
            return HomePlanViewController.className
        case .history:
            return HomeHistoryViewController.className
        }
    }
}

class HomeTabPagerViewModel {

    let memberMeta: [MemberMeta]

    init(memberMeta: [MemberMeta]) {
        self.memberMeta = memberMeta
    }

    func craeteSubViewModel(tab: HomeTab) -> HomeTabViewModel {
        switch tab {
        case .plan:
            return HomePlanViewModel()
        case .history:
            return HomeHistoryViewModel()
        }
    }
}
