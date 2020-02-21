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
import SwiftyJSON

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
            let filteredConferences = userConferences.future
            self.models = filteredConferences

            cellModels = models.map { conference in
                return HomePlanCollectionViewCellModel(conference: conference)
            }
            reusableViewModels = [HomePlanCollectionHeaderViewModel(conference: filteredConferences.first)]
        }
    }
    var models: [WNConference]
    var cellModels: [CollectionViewCellModel] = []
    var reusableViewModels: [CollectionViewReusableViewModel] = []

    let tabTitle = "일정"

    var didUpdateUserGroups: (() -> Void)?

    private var cancelables = Set<AnyCancellable>()

    init(groups: [WNGroup]) {
        self.userGroups = groups

        let userConferences: [WNConference] = groups.first?.conferences ?? []
        let filteredConferences = userConferences.future

        self.models = filteredConferences

        cellModels = filteredConferences.map { conference in
            return HomePlanCollectionViewCellModel(conference: conference)
        }
        reusableViewModels = [HomePlanCollectionHeaderViewModel(conference: filteredConferences.first)]

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
        self.userGroups = groups
        didUpdateUserGroups?()
    }

    var notEventTimeTitle: String {
        return "빨리 오셨네요...! 😮"
    }

    var notEventTimeMessage: String {
        return """
        아직 출석시간이 안되었어요!
        조금만 기다려주세요.
        """
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
                .tryMap { data, response -> WNAttendance in

                        guard let httpResponse = response as? HTTPURLResponse else {
                            throw SwiftyJSONError.invalidJSON
                        }

                        guard (200...399).contains(httpResponse.statusCode) else {
                            let json = try? JSON(data: data)
                            let message = json?["error_description"].stringValue ?? ""
                            throw WNError.responseFailed(message: message)
                        }
                        return try JSONDecoder().decode(WNAttendance.self, from: data)
                }
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
