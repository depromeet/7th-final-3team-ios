//
//  HomeViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/01.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController, ViewModelInjectable {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var pageContainerView: UIView!

    typealias ViewModel = HomeViewModel

    let viewModel: HomeViewModel

    lazy var homeTabPageVC: UIPageViewController = {
        let pageVC = HomeTabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageVC
    }()

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(homeTabPageVC)
        pageContainerView.addSubview(homeTabPageVC.view)
        homeTabPageVC.view.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
