//
//  HomeHistoryCollectionHeaderViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

struct HomeHistoryCollectionHeaderViewModel: CollectionViewReusableViewModel, HasConferenceDate {
    func viewType(kind: String) -> BindableCollectionReusableView.Type? {
        guard kind == UICollectionView.elementKindSectionHeader else { return nil }
        return HomeHistoryCollectionReusableView.self
    }

    let userName = MemberAccess.default.memberMeta?.member.name ?? ""
    let conferenceStartTimeInterval: TimeInterval
    let totalAttendee: Int
    let currentAttendee: Int

    init(conference: WNConference? = nil, attendances: [WNAttendance] = []) {
        self.conferenceStartTimeInterval = conference?.startDate ?? Date().timeIntervalSince1970
        self.totalAttendee = attendances.count
        self.currentAttendee = attendances.reduce(0) { acc, attendance in
            if attendance.presentCondition == .participant {
                return acc + 1
            }
            return acc
        }
    }

    var stateText: String {
        guard conferenceIsToday else {
            return "\(dDay)일 뒤에 만나요! 😉"
        }

        guard currentAttendee != 0 else {
            return "아직 아무도 안 왔어요... 😢"
        }
        guard totalAttendee != currentAttendee else {
            return "전원 출석했어요! ❤️"
        }
        return "\(currentAttendee)명 왔어요! 👋"
    }
}
