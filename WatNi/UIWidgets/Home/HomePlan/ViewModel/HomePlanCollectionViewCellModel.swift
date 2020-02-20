//
//  HomePlanCollectionViewCellModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct HomePlanCollectionViewCellModel: CollectionViewCellModel, HasConferenceDate {

    var cellType: BindableCollectionViewCell.Type {
        return HomePlanCollectionViewCell.self
    }

    let conference: WNConference?
    let isManager: Bool
    var conferenceStartTimeInterval: TimeInterval

    var didTapPhotoButton: ((_ conferenceId: Int, _ isEventTime: Bool) -> Void)?

    init(conference: WNConference? = nil) {
        self.conference = conference
        self.isManager = MemberAccess.default.memberMeta?.isManager ?? false
        self.conferenceStartTimeInterval = conference?.startDate ?? Date().timeIntervalSince1970
    }

    var title: String {
        return conference?.name ?? ""
    }

    var place: String {
        return conference?.location ?? ""
    }

    var notice: String {
        return conference?.notice ?? ""
    }

    var dateOfConference: String {
        let startTimeInterval = conference?.startDate ?? 0
        let startDate = Date(timeIntervalSince1970: startTimeInterval)
        let startDateStr = startDate.toString(format: "M월 dd일 EEEE")
        return startDateStr
    }

    var timeOfConference: String {
        let startTimeInterval = conference?.startDate ?? 0
        let endTimeInterval = conference?.endDate ?? 0

        let startDate = Date(timeIntervalSince1970: startTimeInterval)
        let endDate = Date(timeIntervalSince1970: endTimeInterval)

        let startDateStr = startDate.toString(format: "a HH:mm")
        let endDateStr = endDate.toString(format: "HH:mm")

        return "\(startDateStr) - \(endDateStr)"
    }

    var hasImage: Bool {
        let photoURLStr = conference?.photoURLStr ?? ""
        return !photoURLStr.isEmpty
    }

    var hasNotice: Bool {
        let notice = conference?.notice ?? ""
        return !notice.isEmpty
    }

    var photoURL: URL? {
        guard let photoURLStr = conference?.photoURLStr else { return nil }
        return URL(string: photoURLStr)
    }

    var buttonState: AttendButton.AttendState {
        guard conferenceIsToday else {
            return .before
        }
        // TODO: user 출석 완료 여부 체크
        return .available(isEventTime: isEventTime)
    }

    var isEventTime: Bool {
        let startDate = conference?.startDate ?? 0
        let endDate = conference?.endDate ?? 0

        guard startDate < endDate else {
            return false
        }

        return (startDate...endDate).contains(Date().timeIntervalSince1970)
    }
}
