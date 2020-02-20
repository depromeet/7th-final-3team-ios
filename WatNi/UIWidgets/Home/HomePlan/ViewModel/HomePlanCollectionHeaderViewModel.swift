//
//  HomePlanCollectionHeaderViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

struct HomePlanCollectionHeaderViewModel: CollectionViewReusableViewModel, HasConferenceDate {
    func viewType(kind: String) -> BindableCollectionReusableView.Type? {
        guard kind == UICollectionView.elementKindSectionHeader else { return nil }
        return HomePlanCollectionReusableView.self
    }

    let userName = MemberAccess.default.memberMeta?.member.name ?? ""
    let conferenceStartTimeInterval: TimeInterval

    init(conference: WNConference? = nil) {
        self.conferenceStartTimeInterval = conference?.startDate ?? Date().timeIntervalSince1970
    }

    var stateText: String {
        guard conferenceIsToday else {
            return "\(dDay)일 뒤에 만나요! 😉"
        }

        // TODO: user 출석 여부 반영
        return "\(userName)님 왔나요? 👀"
    }
}
