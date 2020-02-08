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
protocol HomeTabViewController: IndicatorInfoProvider {
    var tabTitle: String { get }
}

extension HomeTabViewController where Self: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}
