//
//  HomePlanCollectionReusableView.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class HomePlanCollectionReusableView: UICollectionReusableView, BindableCollectionReusableView {

    @IBOutlet weak var stateLabel: UILabel!

    var viewModel: CollectionViewReusableViewModel = HomePlanCollectionHeaderViewModel() {
        didSet {
            configureView(viewModel: viewModel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureView(viewModel: CollectionViewReusableViewModel) {
        guard let viewModel = viewModel as? HomePlanCollectionHeaderViewModel else { return }

        stateLabel.text = viewModel.stateText
    }
}
