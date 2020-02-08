//
//  UICollectionView+Nib.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(cells: [UICollectionViewCell.Type], usingNib: Bool = true) {
        cells.forEach {
            if usingNib {
                register($0.nib, forCellWithReuseIdentifier: $0.className)
            } else {
                register($0, forCellWithReuseIdentifier: $0.className)
            }
        }
    }

    func register(headers: [UICollectionReusableView.Type], usingNib: Bool = true) {
        headers.forEach {
            if usingNib {
                register($0.nib,
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                         withReuseIdentifier: $0.className)
            } else {
                register($0,
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                         withReuseIdentifier: $0.className)
            }
        }
    }

    func register(footers: [UICollectionReusableView.Type], usingNib: Bool = true) {
        footers.forEach {
            if usingNib {
                register($0.nib,
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                         withReuseIdentifier: $0.className)
            } else {
                register($0,
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                         withReuseIdentifier: $0.className)
            }
        }
    }
}
