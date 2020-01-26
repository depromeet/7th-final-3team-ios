//
//  CoachViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/26.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Combine

class CoachViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = CoachViewModel

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!

    var viewModel: CoachViewModel
    private var cancelables = Set<AnyCancellable>()

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = viewModel.memberNameStr
        subscribeLogoutButton()
    }

    private func subscribeLogoutButton() {
        logoutButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            let onboardingVC = OnBoardingViewController(nibName: OnBoardingViewController.className, bundle: nil)
            self?.navigationController?.setViewControllers([onboardingVC], animated: false)
        }.store(in: &cancelables)
    }
}
