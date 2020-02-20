//
//  HomeHistoryCollectionHeaderViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/20.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

struct HomeHistoryCollectionHeaderViewModel: CollectionViewReusableViewModel {
    func viewType(kind: String) -> BindableCollectionReusableView.Type? {
        guard kind == UICollectionView.elementKindSectionHeader else { return nil }
        return HomeHistoryCollectionReusableView.self
    }

    let userName = MemberAccess.default.memberMeta?.member.name ?? ""

    var stateText: String {
        return "\(userName)님 왔나요? 👀"
    }
}