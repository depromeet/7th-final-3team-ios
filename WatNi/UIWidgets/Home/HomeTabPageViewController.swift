//
//  HomeTabPageViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class HomeTabPageViewController: UIPageViewController {

    private var pagesVC: [UIViewController] = {
        let planViewModel = HomePlanViewModel()
        let planVC = HomePlanViewController(viewModel: planViewModel,
                                            nibName: HomePlanViewController.className)

        let historyViewModel = HomeHistoryViewModel()
        let historyVC = HomeHistoryViewController(viewModel: historyViewModel,
                                                  nibName: HomeHistoryViewController.className)

        return [planVC, historyVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        if let firstVC = pagesVC.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension HomeTabPageViewController: UIPageViewControllerDataSource {

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
