//
//  HomePlanViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Combine


enum HomePlanSectionType {
    case plan
}

class HomePlanViewModel: HomeTabViewModel, CollectionViewModelBase {

    typealias BaseModel = WNConference
    typealias SectionType = HomePlanSectionType
    typealias ModelCollection = [WNConference]
    typealias CellModel = Array<CollectionViewCellModel>.Element
    typealias ReusableViewModel = CollectionViewReusableViewModel

    var userGroups: [WNGroup] {
        didSet {
            let userConferences: [WNConference] = userGroups.first?.conferences ?? []
            self.models = userConferences

            cellModels = models.map { conference in
                return HomePlanCollectionViewCellModel(conference: conference)
            }
        }
    }
    var models: [WNConference]
    var cellModels: [CollectionViewCellModel] = []
    var reusableViewModels: [CollectionViewReusableViewModel] = []

    let tabTitle = "일정"

    private var cancelables = Set<AnyCancellable>()

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

    func updateGroups(_ groups: [WNGroup]) {
        self.userGroups = groups
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

        return 227 + 15
    }

    private func cellNoticeHeight(indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        guard let cellModel = cellModels[safe: indexPath.row] as? HomePlanCollectionViewCellModel else {
            return .zero
        }

        guard let noticeText = cellModel.conference?.notice, !noticeText.isEmpty else {
            return .zero
        }

        let labelHeight = TextUtil.contentsHeight(noticeText,
                                                  font: UIFont.spoqaFont(ofSize: 20, weight: .regular),
                                                  maxSize: CGSize(width: cellWidth,
                                                                  height: CGFloat.greatestFiniteMagnitude))
        return labelHeight + 30
    }

    func cellHeight(cellWidth: CGFloat, indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 163
        let imageHeight = cellImageHeight(indexPath: indexPath)
        let noticeHeight = cellNoticeHeight(indexPath: indexPath, cellWidth: cellWidth)

        return defaultHeight + imageHeight + noticeHeight
    }
}

extension HomePlanViewModel {
    func authStatus(completion: @escaping (Result<Void, PHPhotoLibrary.PhotoError>) -> Void) {
        PHPhotoLibrary.authStatus { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func participate(_ conferenceId: Int, image: UIImage, completionHandler: @escaping (Result<WNAttendance, Error>) -> Void) {

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            guard let groupId = self.userGroups.first?.groupId else {
                return
            }

            let base64ImageStr = image.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""

            let body: [String: String] = [
                "attendanceType": "PHOTO",
                "base64Image": base64ImageStr
            ]

            let request = URLRequest(target: AttendanceTarget.createAttendance(body,
                                                                               groupId: groupId,
                                                                               conferenceId: conferenceId))
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .decode(type: WNAttendance.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("[Attendance][생성] 실패: \(error)")
                        completionHandler(.failure(error))
                    }
                }, receiveValue: { attendance in
                    print("[Attendance][생성] \(attendance)")
                    completionHandler(.success(attendance))
                }).store(in: &self.cancelables)
        }

    }
}
