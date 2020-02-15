//
//  CreatePlanViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/06.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Photos
import UIKit

final class CreatePlanViewModel {

    enum InputRow {
        case title
        case date
        case time(TimeType)
        case place
        case notice
        case image
    }

    enum TimeType {
        case fromTime
        case toTime
    }

    let group: WNGroup
    private(set) var title: String = ""
    private(set) var place: String = ""
    private(set) var notice: String = ""
    private(set) var date: Date = Date()
    private(set) var fromTime: Date
    private(set) var toTime: Date

    var selectedTimePicker: TimeType?

    var submitAvailable: Bool {
        return !title.isEmpty && !place.isEmpty
    }

    init(group: WNGroup) {
        let minuteGap = Date().component(of: .minute) * -1
        let fromComponent = DateComponents(hour: 1, minute: minuteGap)
        let toComponent = DateComponents(hour: 2, minute: minuteGap)

        self.group = group
        self.fromTime = Calendar.current.date(byAdding: fromComponent, to: Date()) ?? Date()
        self.toTime = Calendar.current.date(byAdding: toComponent, to: Date()) ?? Date()
    }

    func defaultValue(_ rowType: InputRow) -> String {

        switch rowType {
        case .date:
            return dateFormatter(for: .date).string(from: date)
        case .time(let timeType):

            switch timeType {
            case .fromTime:
                return dateFormatter(for: .time).string(from: fromTime)
            case .toTime:
                return dateFormatter(for: .time).string(from: toTime)
            }
        default:
            return ""
        }
    }

    func update<T>(_ rowType: InputRow, newValue: T) {

        let stringValue = newValue as? String ?? ""
        let dateValue = newValue as? Date ?? Date()

        switch rowType {
        case .title:
            self.title = stringValue
        case .place:
            self.place = stringValue
        case .notice:
            self.notice = stringValue
        case .date:
            self.date = dateValue
        case .time(let timeType):
            switch timeType {
            case .fromTime:
                self.fromTime = dateValue
            case .toTime:
                self.toTime = dateValue
            }
        case .image:
            break
        }
    }

    func dateFormatter(for mode: UIDatePicker.Mode) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")

        switch mode {
        case .date:
            formatter.dateFormat = "yyyy년 MM월 dd일"
        case .time:
            formatter.timeStyle = .short
        default:
            break
        }
        return formatter
    }

    func photoErrorMessage(error: PHPhotoLibrary.PhotoError) -> String {
        switch error {
        case .restricted:
            return "사진 접근에 제약이 있습니다."
        case .denied:
            return "앱 설정에서 사진 접근을 허용해주세요."
        }
    }

    func authStatus(completion: @escaping (Result<Void, PHPhotoLibrary.PhotoError>) -> Void) {
        PHPhotoLibrary.authStatus { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func createPlan(completion: @escaping (Result<Void, Error>) -> Void) {

        let fromDate = Calendar.current.date(from: DateComponents(date: date, time: fromTime)) ?? Date()
        let toDate = Calendar.current.date(from: DateComponents(date: date, time: toTime)) ?? Date()

        let fromTimeInterval = Int(fromDate.timeIntervalSince1970)
        let toTimeInterval = Int(toDate.timeIntervalSince1970)

        guard fromTimeInterval < toTimeInterval else {
            completion(.failure(WNError.invalidInput(reason: .cannotFormTimeRange)))
            return
        }

        let requestBody = WNConferenceRequest(name: title, description: "", locationInfo: place,
                                              startAt: fromTimeInterval, endAt: toTimeInterval)

        ConferenceProvider.createConference(groupId: group.groupId, requestBody: requestBody) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let conference):
                print(conference)
                // TODO: Conference 이미지 URL 추가, notice 추가
            }
        }
    }
}
