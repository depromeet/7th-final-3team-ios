//
//  SideMenuViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/21.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SideMenuViewModel

    let viewModel: SideMenuViewModel

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
}
