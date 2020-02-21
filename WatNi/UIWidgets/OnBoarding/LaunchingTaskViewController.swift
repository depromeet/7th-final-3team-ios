//
//  LaunchingTaskViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/27.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

/// 초기 진입 화면 정의
enum InitialScene {
    /// 온보딩 화면
    case onboarding
    /// 모임 생성, 참여 이력이 없는 사용자 화면
    case coach
    /// 모임을 생성한 사용자
    case home
}

class LaunchingTaskViewController: UIViewController {

    let worker = LaunchingTaskWorker()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViewController { [weak self] scene, groups  in
            let viewController: UIViewController
            switch scene {
            case .onboarding:
                viewController = OnBoardingPageViewController(transitionStyle: .scroll,
                                                              navigationOrientation: .horizontal,
                                                              options: nil)
            case .coach:
                let viewModel = CoachViewModel()
                viewController = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
            case .home:
                let viewModel = HomeTabPagerViewModel(groups: groups)
                viewController = HomeTabPagerViewController(viewModel: viewModel,
                                                            nibName: HomeTabPagerViewController.className)
            }
            self?.navigationController?.pushViewController(viewController, animated: false)
            self?.navigationController?.viewControllers.removeAll(where: { prevVC in
                return prevVC != viewController
            })
        }
    }

    private func setupInitialViewController(completionHandler: @escaping (InitialScene, [WNGroup]) -> Void) {

        guard MemberAccess.default.isLogin else {
            completionHandler(.onboarding, [])
            return
        }

        worker.initialViewController { [weak self] (result) in
            switch result {
            case .failure:
                completionHandler(.onboarding, [])
            case .success:
                self?.worker.memberMetaData { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        completionHandler(.onboarding, [])
                    case .success(let metaData):
                        let scene: InitialScene = metaData.groups.isEmpty ? .coach : .home
                        completionHandler(scene, metaData.groups)
                    }
                }
            }
        }
    }
}
