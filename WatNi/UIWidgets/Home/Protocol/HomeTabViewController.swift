//
//  HomeTabViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

/// Home의 Tab별 ViewController 공통 구현
protocol HomeTabViewController: IndicatorInfoProvider, ViewModelInjectable {
    var viewModel: ViewModel { get }
    var tabTitle: String { get }
    var collectionView: UICollectionView! { get set }
    var managerEmptyView: UIStackView! { get set }
    var participantEmptyView: UIStackView! { get set }
    var participantEmptyImageView: UIImageView! { get set }
    func appearView()
}

extension HomeTabViewController where Self: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}

extension HomeTabViewController {
    func appearView() {
        guard let viewModel = viewModel as? HomeTabViewModel else {
            return
        }
        collectionView.isHidden = viewModel.shouldHideCollectionView
        managerEmptyView.isHidden = viewModel.shouldHideManagerEmptyView
        participantEmptyView.isHidden = viewModel.shouldHideParticipantEmptyView
        participantEmptyImageView.isHidden = viewModel.shouldHideParticipantEmptyView
    }
}
