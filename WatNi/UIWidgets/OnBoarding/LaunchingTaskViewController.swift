//
//  LaunchingTaskViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/27.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class LaunchingTaskViewController: UIViewController {

    /// 초기 진입 화면 정의
    enum InitialScene {
        /// 온보딩 화면
        case onboarding
        /// 모임 생성, 참여 이력이 없는 사용자 화면
        case coach
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViewController { [weak self] scene in
//            let viewController: UIViewController
//            switch scene {
//            case .onboarding:
//                viewController = OnBoardingViewController(nibName: OnBoardingViewController.className, bundle: nil)
//            case .coach:
//                let viewModel = CoachViewModel()
//                viewController = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
//            }

            let viewModel = CreatePlanViewModel()
            let viewController = CreatePlanViewController(viewModel: viewModel,
                                                          nibName: CreatePlanViewController.className)
            self?.navigationController?.present(viewController, animated: true, completion: nil)
        }
    }

    private func setupInitialViewController(completionHandler: @escaping (InitialScene) -> Void) {

        guard MemberAccess.default.isLogin else {
            completionHandler(.onboarding)
            return
        }

        MemberAccess.default.refreshToken { (result) in
            switch result {
            case .failure:
                completionHandler(.onboarding)
            case .success:
                // TODO: 사용자의 모임 정보에 대한 API 반영하여 화면 변경
                completionHandler(.coach)
            }
        }
    }
}
