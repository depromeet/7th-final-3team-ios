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

    private(set) var groups: [WNGroup]

    init(groups: [WNGroup]) {
        let sortedGroups: [WNGroup] = groups.map { group in
            var sortedGroup = group
            let sortedConferences = group.conferences.sorted(by: >)
            sortedGroup.conferences = sortedConferences
            return sortedGroup
        }
        self.groups = sortedGroups
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userGroupUpdated),
                                               name: .userGroupIsUpdated,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func userGroupUpdated(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: [WNGroup]],
            let groups = userInfo["groups"] else {
                return
        }
        self.groups = groups
    }

    var groupTitle: String {
        guard let group = groups.first else { return "" }

        return group.name
    }
}
