//
//  HasViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

/// View가 가져야 하는 ViewModel에 대한 정의
protocol HasViewModel {
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
    func configure(viewModel: ViewModel)
}
