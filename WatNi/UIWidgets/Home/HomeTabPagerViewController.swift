//
//  HomeTabPagerViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class HomeTabPagerViewController: ButtonBarPagerTabStripViewController, ViewModelInjectable {

    typealias ViewModel = HomeTabPagerViewModel

    @IBOutlet weak var logoutButton: UIButton!

    let viewModel: HomeTabPagerViewModel

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let planViewModel = HomePlanViewModel(groups: viewModel.groups)
        let planVC = HomePlanViewController(viewModel: planViewModel,
                                            nibName: HomePlanViewController.className)
        let historyViewModel = HomeHistoryViewModel(groups: viewModel.groups)
        let historyVC = HomeHistoryViewController(viewModel: historyViewModel,
                                                  nibName: HomeHistoryViewController.className)
        return [planVC, historyVC]
    }

    override func viewDidLoad() {
        setupTab()
        super.viewDidLoad()
    }

    private func setupTab() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont.spoqaFont(ofSize: 16, weight: .regular)
        settings.style.buttonBarItemTitleColor = WNColor.black87
        settings.style.selectedBarBackgroundColor = WNColor.primaryRed
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemsShouldFillAvailableWidth = false

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _, indexIsChanged: Bool, _) -> Void in
            guard indexIsChanged == true else { return }
            newCell?.label.textColor = WNColor.black87
            oldCell?.label.textColor = UIColor(decimalRed: 34, green: 34, blue: 34, alpha: 0.4)
        }
    }

    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        MemberAccess.default.logout()
        let onboardingVC = OnBoardingPageViewController(transitionStyle: .scroll,
                                                        navigationOrientation: .horizontal,
                                                        options: nil)
        navigationController?.setViewControllers([onboardingVC], animated: false)
    }
}
