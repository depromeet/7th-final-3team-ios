//
//  HomeHistoryCollectionReusableView.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class HomeHistoryCollectionReusableView: UICollectionReusableView, BindableCollectionReusableView {

    @IBOutlet weak var stateLabel: UILabel!

    var viewModel: CollectionViewReusableViewModel = HomeHistoryCollectionHeaderViewModel() {
        didSet {
            configureView(viewModel: viewModel)
        }
    }

    func configureView(viewModel: CollectionViewReusableViewModel) {
        guard let viewModel = viewModel as? HomeHistoryCollectionHeaderViewModel else { return }

        stateLabel.text = viewModel.stateText
    }
}
