//
//  HomeHistoryFilterCollectionViewCellModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

struct HomeHistoryFilterCollectionViewCellModel: CollectionViewCellModel {
    var cellType: BindableCollectionViewCell.Type {
        return HomeHistoryFilterCollectionViewCell.self
    }
}
