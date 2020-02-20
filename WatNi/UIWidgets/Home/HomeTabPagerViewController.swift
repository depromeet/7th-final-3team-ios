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
import SideMenu

class HomeTabPagerViewController: ButtonBarPagerTabStripViewController, ViewModelInjectable {

    typealias ViewModel = HomeTabPagerViewModel

    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet private weak var naviTitleLabel: UILabel!
    @IBOutlet weak var dimmedView: UIView!

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

        naviTitleLabel.text = viewModel.groupTitle
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

    @IBAction func sideMenuBtnTapped(_ sender: UIButton) {
        let viewModel = SideMenuViewModel()
        let sideMenuVC = SideMenuViewController(viewModel: viewModel,
                                                nibName: SideMenuViewController.className)
        let navigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
        navigationController.statusBarEndAlpha = 0
        navigationController.presentationStyle = .menuSlideIn
        navigationController.presentDuration = 0.5
        navigationController.menuWidth = self.view.frame.width - 71
        navigationController.sideMenuDelegate = self
        present(navigationController, animated: true, completion: nil)
    }
}

extension HomeTabPagerViewController: SideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        dimmedView.isHidden = false
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        dimmedView.isHidden = true
    }
}
