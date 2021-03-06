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

            // TODO: 이름 중복 제거, workaround
            let uniqueModels: [WNAttendance] = models.reduce([WNAttendance]()) { (acc, cur) in
                let duplicate = acc.first(where: { attendance in
                    attendance.name == cur.name
                })

                if duplicate == nil {
                    return acc + [cur]
                }
                return acc
            }
            cellModels = uniqueModels.map { attendance in
                return HomeHistoryCollectionViewCellModel(attendance: attendance)
            }

            let conference = self.visibleConference
            let filterCellModel = HomeHistoryFilterCollectionViewCellModel(totalCount: uniqueModels.count,
                                                                           conference: conference)
            cellModels.insert(filterCellModel, at: 0)
            reusableViewModels = [HomeHistoryCollectionHeaderViewModel(conference: conference, attendances: uniqueModels)]
        }
    }
    var cellModels: [CollectionViewCellModel] = []
    var reusableViewModels: [CollectionViewReusableViewModel] = []

    var didUpdateUserGroups: (() -> Void)?

    private var cancelables = Set<AnyCancellable>()

    init(groups: [WNGroup]) {
        self.userGroups = groups

        reusableViewModels = [HomeHistoryCollectionHeaderViewModel(attendances: [])]

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userGroupUpdated),
                                               name: .userGroupIsUpdated,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 현재 끝나지 않은 가장 최신의 일정이 노출됨
    var visibleConference: WNConference? {
        guard let group = userGroups.first else {
            return nil
        }

        let conference = group.conferences.sorted(by: <).first(where: {
            return Date().timeIntervalSince1970 < $0.endDate
        })
        return conference
    }

    @objc func userGroupUpdated(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: [WNGroup]],
            let groups = userInfo["groups"] else {
                return
        }
        self.userGroups = groups
        didUpdateUserGroups?()
    }

    func attendances(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let group = userGroups.first, let conferenceId = visibleConference?.conferenceID else {
            return
        }

        let request = URLRequest(target: AttendanceTarget.searchAttendances(groupId: group.groupId, conferenceId: conferenceId))

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> [WNAttendance] in

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw SwiftyJSONError.invalidJSON
                }

                guard (200...399).contains(httpResponse.statusCode) else {
                    let json = try? JSON(data: data)
                    let message = json?["error_description"].stringValue ?? ""
                    throw WNError.responseFailed(message: message)
                }
                return try JSONDecoder().decode([WNAttendance].self, from: data)
        }.eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("[Attendance][조회] 실패: \(error)")
                    completionHandler(.failure(error))
                }
            }, receiveValue: { attendances in
                print("[Attendance][조회] 성공: \(attendances)")
                self.models = attendances
                completionHandler(.success(()))
            }).store(in: &cancelables)
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
