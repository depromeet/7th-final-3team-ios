//
//  HomePlanCollectionHeaderViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

struct HomePlanCollectionHeaderViewModel: CollectionViewReusableViewModel {
    func viewType(kind: String) -> BindableCollectionReusableView.Type? {
        guard kind == UICollectionView.elementKindSectionHeader else { return nil }
        return HomePlanCollectionReusableView.self
    }

}
