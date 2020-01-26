//
//  OnBoardingViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Combine

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var startButton: SubmitButton!
    private var cancelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            let signinViewModel = SignInViewModel()
            let signinVC = SignInViewController(viewModel: signinViewModel,
                                                nibName: SignInViewController.className)
            self?.navigationController?.pushViewController(signinVC, animated: true)
        }.store(in: &cancelables)
    }
}
