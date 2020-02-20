//
//  HomeHistoryCollectionViewCell.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/19.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import Kingfisher

class HomeHistoryAttendanceCollectionViewCell: UICollectionViewCell, BindableCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var attendStatusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var viewModel: CollectionViewCellModel = HomeHistoryCollectionViewCellModel() {
        didSet {
            configureCell(viewModel: viewModel)
        }
    }

    func configureCell(viewModel: CollectionViewCellModel) {
        guard let viewModel = viewModel as? HomeHistoryCollectionViewCellModel else { return }

        imageView.kf.setImage(with: viewModel.photoURL)
        nameLabel.text = viewModel.name
        attendStatusLabel.text = viewModel.statusStr
        attendStatusLabel.textColor = viewModel.statusColor
    }
}
