//
//  ViewController.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let signupViewModel = SignupViewModel()
        let signupVC = SignupViewController(viewModel: signupViewModel, nibName: SignupViewController.className)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}
