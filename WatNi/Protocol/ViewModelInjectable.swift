//
//  ViewModelInjectable.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelInjectable where Self: UIViewController {
    associatedtype ViewModel
    var viewModel: ViewModel { get }
    init(viewModel: ViewModel, nibName: String)
}
