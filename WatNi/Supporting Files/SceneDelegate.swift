//
//  SceneDelegate.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: scene)

        let navigationController = UINavigationController(rootViewController: firstVC)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        navigationController.navigationBar.isHidden = true
    }

    private var firstVC: UIViewController {
        // TODO: 1. Token 처리에 대한 조건 분기 정리
        // TODO: 2. 사용자의 모임 정보에 대한 API 반영
        if MemberAccess.default.member == nil {
            return OnBoardingViewController(nibName: OnBoardingViewController.className, bundle: nil)
        }

        let viewModel = CoachViewModel()
        let coachVC = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
        return coachVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
