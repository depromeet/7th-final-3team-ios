//
//  SignInViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SignInViewModel

    let viewModel: SignInViewModel

    required init(viewModel: SignInViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func signInBtnTapped(_ sender: UIButton) {
    }
}
