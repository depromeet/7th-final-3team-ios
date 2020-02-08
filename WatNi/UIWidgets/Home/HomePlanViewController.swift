//
//  HomePlanViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomePlanViewController: UIViewController, ViewModelInjectable, HomeTabViewController {

    typealias ViewModel = HomePlanViewModel

    let viewModel: HomePlanViewModel

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tabTitle: String {
        return viewModel.tabTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
