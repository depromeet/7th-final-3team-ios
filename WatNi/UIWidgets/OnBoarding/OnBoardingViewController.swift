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
import Lottie

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var startButton: SubmitButton!
    @IBOutlet weak var pageControl: UIPageControl!

    var currentPage: Int = 0
    private var cancelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.currentPage = currentPage

        startButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            let signinViewModel = SignInViewModel()
            let signinVC = SignInViewController(viewModel: signinViewModel,
                                                nibName: SignInViewController.className)
            self?.navigationController?.pushViewController(signinVC, animated: true)
        }.store(in: &cancelables)
    }
}
