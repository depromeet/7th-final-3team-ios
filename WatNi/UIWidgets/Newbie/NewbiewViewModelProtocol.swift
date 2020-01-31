//
//  NewbiewViewModelProtocol.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/01.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

protocol NewbieViewModelProtocol {
    var titleGuideText: String { get }
    var submitAvailable: Bool { get }
    func update(input: String)
    func createUnderlineViewModel() -> UnderlineTextFieldViewModel
    func submitAction(completionHandler: @escaping (Result<Decodable, Error>) -> Void)
}
