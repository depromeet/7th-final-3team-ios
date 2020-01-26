//
//  UserLoginSplashViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/27.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class LaunchingTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViewController { [weak self] viewController in
            self?.navigationController?.setViewControllers([viewController], animated: false)
        }
    }

    private func setupInitialViewController(completionHandler: @escaping (UIViewController) -> Void) {
        let onboardingVC = OnBoardingViewController(nibName: OnBoardingViewController.className, bundle: nil)
        guard MemberAccess.default.isLogin else {
            completionHandler(onboardingVC)
            return
        }

        MemberAccess.default.refreshToken { (result) in
            switch result {
            case .failure:
                completionHandler(onboardingVC)
            case .success:
                // TODO: 사용자의 모임 정보에 대한 API 반영하여 화면 변경
                let viewModel = CoachViewModel()
                let coachVC = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
                completionHandler(coachVC)
            }
        }
    }
}
