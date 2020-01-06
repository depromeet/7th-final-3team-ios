//
//  SignupViewController.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SignupViewModel


    let viewModel: SignupViewModel

    required init(viewModel: SignupViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
