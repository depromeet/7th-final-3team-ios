//
//  HomePlanCollectionViewCell.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class HomePlanCollectionViewCell: UICollectionViewCell, BindableCollectionViewCell {

    @IBOutlet weak var conferenceTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var separaterView: UIView!
    @IBOutlet weak var moreButton: UIButton!

    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var descLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descLabelBottomConstraint: NSLayoutConstraint!

    var viewModel: CollectionViewCellModel = HomePlanCollectionViewCellModel() {
        didSet {
            configureCell(viewModel: viewModel)
        }
    }

    func configureCell(viewModel: CollectionViewCellModel) {
        guard let viewModel = viewModel as? HomePlanCollectionViewCellModel else { return }

        conferenceTitleLabel.text = viewModel.title
        placeLabel.text = viewModel.place
        dateLabel.text = viewModel.dateOfConference
        timeLabel.text = viewModel.timeOfConference

        if !viewModel.hasImage {
            imageTopConstraint.constant = 0
            imageBottomConstraint.constant = 0
        } else {
            imageTopConstraint.constant = 15
            imageBottomConstraint.constant = 15
        }

        if !viewModel.hasNotice {
            descLabelTopConstraint.constant = 0
            descLabelBottomConstraint.constant = 0
        } else {
            descLabelTopConstraint.constant = 13
            descLabelBottomConstraint.constant = 17
        }
        imageView.isHidden = !viewModel.hasImage
        descLabel.isHidden = !viewModel.hasNotice
        separaterView.isHidden = !viewModel.hasNotice
        moreButton.isHidden = !viewModel.isManager
    }
}
