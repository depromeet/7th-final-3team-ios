//
//  OnBoardingPageViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/13.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingPageViewController: UIPageViewController {

    private var pagesVC: [UIViewController] = {
        let lottieVC1 = OnBoardingLottieViewController(nibName: OnBoardingLottieViewController.className,
                                                      bundle: nil)
        lottieVC1.jsonName = "watni_1"
        lottieVC1.head = "저 왔어요!"
        lottieVC1.desc = "말할 필요없이"
        lottieVC1.currentPage = 0

        let lottieVC2 = OnBoardingLottieViewController(nibName: OnBoardingLottieViewController.className,
                                                      bundle: nil)
        lottieVC2.jsonName = "watni_2"
        lottieVC2.head = "찰칵!"
        lottieVC2.desc = "출석완료"
        lottieVC2.currentPage = 1

        let onboardingVC = OnBoardingViewController(nibName: OnBoardingViewController.className,
                                                    bundle: nil)
        onboardingVC.currentPage = 2
        return [lottieVC1, lottieVC2, onboardingVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        if let firstVC = pagesVC.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension OnBoardingPageViewController: UIPageViewControllerDataSource {

    private enum Order {
        case before
        case after
    }

    private func sideViewController(of order: Order, current viewController: UIViewController) -> UIViewController? {
        guard let index = pagesVC.firstIndex(of: viewController) else { return nil }

        let targetIndex: Int
        switch order {
        case .before:
            targetIndex = index - 1
        case .after:
            targetIndex = index + 1
        }

        guard let targetVC = pagesVC[safe: targetIndex] else {
            return nil
        }

        return targetVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let beforeVC = sideViewController(of: .before, current: viewController)

        return beforeVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let afterVC = sideViewController(of: .after, current: viewController)

        return afterVC
    }
}
