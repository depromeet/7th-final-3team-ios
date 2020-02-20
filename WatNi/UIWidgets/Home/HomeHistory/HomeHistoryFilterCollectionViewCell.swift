//
//  HomeHistoryFilterCollectionViewCell.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class HomeHistoryFilterCollectionViewCell: UICollectionViewCell, BindableCollectionViewCell {

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    var viewModel: CollectionViewCellModel = HomeHistoryFilterCollectionViewCellModel() {
        didSet {
            configureCell(viewModel: viewModel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterViewTapped))
        filterView.addGestureRecognizer(tapGesture)
    }

    @objc func filterViewTapped(_ sender: UITapGestureRecognizer) {
        (viewModel as? HomeHistoryFilterCollectionViewCellModel)?.didTapFilterView?()
    }

    func configureCell(viewModel: CollectionViewCellModel) {
        guard let viewModel = viewModel as? HomeHistoryFilterCollectionViewCellModel else { return }

        countLabel.text = viewModel.totalCountStr
        filterLabel.text = viewModel.filterViewStr
    }
}
