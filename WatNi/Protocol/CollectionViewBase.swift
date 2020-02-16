//
//  CollectionViewBase.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewModelBase {
    associatedtype BaseModel
    associatedtype ModelCollection: Swift.Collection
    associatedtype SectionType: Hashable

    /// ViewModel의 Model Collection
    var models: ModelCollection { get set }
}

/// CollectionViewModel의 CellModel 정의
protocol HasCellModel where Self: CollectionViewModelBase {
    associatedtype CellModel
    associatedtype CellModelCollection: Swift.Collection where CellModelCollection.Element == CellModel

    /// Cell의 매핑 정보(섹션별 Cell 정보)
    var cellModels: CellModelCollection { get set }

    /// 바인딩된 CellModel
    ///
    /// - Parameter indexPath: 타겟 indexPath
    /// - Returns: CellModel
    func cellModel(indexPath: IndexPath) -> CollectionViewCellModel?
}

/// CollectionViewModel의 ReusableViewModel 정의
protocol HasReusableViewModel where Self: CollectionViewModelBase {
    associatedtype ReusableViewModel
    associatedtype ReusableViewModelCollection: Swift.Collection where ReusableViewModelCollection.Element == ReusableViewModel

    /// 섹션별 Header, Footer 정보
    var reusableViewModels: ReusableViewModelCollection { get set }

    /// 바인딩된 ReusableViewModel
    ///
    /// - Parameter sectionType: 타겟 sectionType
    /// - Returns: ReusableViewModel
    func reusableViewModel(sectionType: SectionType) -> CollectionViewReusableViewModel?
}

/// CollectionView 공통 CellModel
protocol CollectionViewCellModel {
    /// viewModel에 바인딩되는 cell의 type
    var cellType: BindableCollectionViewCell.Type { get }
}

/// CollectionView 공통 ReusableViewModel
protocol CollectionViewReusableViewModel {
    /// viewModel에 바인딩되는 reusableView의 type
    func viewType(kind: String) -> BindableCollectionReusableView.Type?
}

/// CollectionViewCell viewModel 정의 및 viewModel 통한 cell 업데이트 정의
protocol BindableCollectionViewCell: UICollectionViewCell {
    var viewModel: CollectionViewCellModel { get set }
    func configureCell(viewModel: CollectionViewCellModel)
}

/// CollectionViewReusableView의 viewModel 정의 및 viewModel 통한 ReusableView 업데이트 정의
protocol BindableCollectionReusableView: UICollectionReusableView {
    var viewModel: CollectionViewReusableViewModel { get set }
    func configureView(viewModel: CollectionViewReusableViewModel)
}
