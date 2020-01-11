//
//  OnBoardingViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signInBtnTapped(_ sender: UIButton) {
        let signinViewModel = SignInViewModel()
        let signinVC = SignInViewController(viewModel: signinViewModel,
                                            nibName: SignInViewController.className)
        navigationController?.pushViewController(signinVC, animated: true)
    }

    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        let signupViewModel = SignupViewModel()
        let signupVC = SignupViewController(viewModel: signupViewModel,
                                            nibName: SignupViewController.className)
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
