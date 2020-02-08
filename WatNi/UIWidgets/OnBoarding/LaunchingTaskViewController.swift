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
        /// 모임을 생성한 사용자
        case home
    }

    let worker = LaunchingTaskWorker()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViewController { [weak self] scene, memberMeta in
            let viewController: UIViewController
            switch scene {
            case .onboarding:
                viewController = OnBoardingViewController(nibName: OnBoardingViewController.className, bundle: nil)
            case .coach:
                let viewModel = CoachViewModel(memberMeta: memberMeta)
                viewController = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
            case .home:
                let viewModel = HomeTabPagerViewModel()
                let viewController = HomeTabPagerViewController(viewModel: viewModel,
                                                            nibName: HomeTabPagerViewController.className)
            }
            self?.navigationController?.pushViewController(viewController, animated: false)
        }
    }

    private func setupInitialViewController(completionHandler: @escaping (InitialScene, [MemberMeta]) -> Void) {

        guard MemberAccess.default.isLogin else {
            completionHandler(.onboarding, [])
            return
        }

        MemberAccess.default.refreshToken { [weak self] (result) in
            switch result {
            case .failure:
                completionHandler(.onboarding, [])
            case .success:
                self?.worker.userMetaData { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        completionHandler(.coach, [])
                    case .success(let metaData):
                        completionHandler(.home, metaData)
                    }
                }
            }
        }
    }
}
