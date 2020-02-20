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

            let conference = userGroups.first?.conferences.first
            let filterCellModel = HomeHistoryFilterCollectionViewCellModel(totalCount: models.count,
                                                                           conference: conference)
            cellModels.insert(filterCellModel, at: 0)
            reusableViewModels = [HomeHistoryCollectionHeaderViewModel(conference: conference, attendances: models)]
        }
    }
    var cellModels: [CollectionViewCellModel] = []
    var reusableViewModels: [CollectionViewReusableViewModel] = []

    private var cancelables = Set<AnyCancellable>()

    init(groups: [WNGroup]) {
        self.userGroups = groups

        reusableViewModels = [HomeHistoryCollectionHeaderViewModel(attendances: [])]
    }

    func attendances(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let group = userGroups.first, let conferenceId = group.conferences.first?.conferenceID else { return }

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
