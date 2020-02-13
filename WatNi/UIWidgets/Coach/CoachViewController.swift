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
            MemberAccess.default.logout()
            let onboardingVC = OnBoardingPageViewController(transitionStyle: .scroll,
                                                            navigationOrientation: .horizontal,
                                                            options: nil)
            self?.navigationController?.setViewControllers([onboardingVC], animated: false)
        }.store(in: &cancelables)
    }

    @IBAction func createGroupTapped(_ sender: UITapGestureRecognizer) {
        let viewModel = CreateGroupViewModel()
        let newbieVC = NewbieViewController(viewModel: viewModel, nibName: NewbieViewController.className)
        navigationController?.pushViewController(newbieVC, animated: true)
    }

    @IBAction func enterGroupTapped(_ sender: UITapGestureRecognizer) {
        let viewModel = UserCodeViewModel()
        let newbieVC = NewbieViewController(viewModel: viewModel, nibName: NewbieViewController.className)
        navigationController?.pushViewController(newbieVC, animated: true)
    }
}
