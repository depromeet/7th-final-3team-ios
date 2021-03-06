//
//  WNError.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/15.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Moya

protocol ErrorReason {
    var message: String { get }
}

enum WNError: Error {
    case invalidInput(reason: InvalidInputReason)
    case invalidStatusCode(response: Moya.Response)
    case responseFailed(message: String)

    var userMessage: String {
        switch self {
        case .invalidInput(let reason):
            return reason.message
        case .invalidStatusCode(let moyaResponse):
            return moyaResponse.description
        case .responseFailed(let message):
            return message
        }
    }
}

// MARK: InvalidInputReason
extension WNError {
    enum InvalidInputReason: ErrorReason {
        case cannotFormTimeRange
        case emptyRequestBody

        var message: String {
            switch self {
            case .cannotFormTimeRange:
                return "시작시간이 종료시간보다 빠를 수 없습니다."
            case .emptyRequestBody:
                return "Request Body가 누락되었습니다."
            }
        }
    }
}
