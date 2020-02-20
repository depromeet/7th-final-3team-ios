//
//  HomeHistoryViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UIKit

class HomeHistoryViewController: UIViewController, ViewModelInjectable, HomeTabViewController {

    typealias ViewModel = HomeHistoryViewModel

    @IBOutlet weak var collectionView: UICollectionView!

    let viewModel: HomeHistoryViewModel

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tabTitle: String {
        return viewModel.tabTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cells: [HomeHistoryFilterCollectionViewCell.self,
                                        HomeHistoryAttendanceCollectionViewCell.self])
        collectionView.register(headers: [HomePlanCollectionReusableView.self])

        searchAttendances()
    }

    private func searchAttendances() {
        viewModel.attendances { [weak self] (result) in
            switch result {
            case .success:
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = viewModel.cellModel(indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        let dqCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.cellType.className, for: indexPath)
        guard let cell = dqCell as? BindableCollectionViewCell else {
            return dqCell
        }
        cell.viewModel = cellModel

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableViewModel = viewModel.reusableViewModel(sectionType: .attend),
            let viewType = reusableViewModel.viewType(kind: kind) else {
                return UICollectionReusableView()
        }

        let dqView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: viewType.className,
                                                                     for: indexPath)
        guard let reusableView = dqView as? BindableCollectionReusableView else {
            return dqView
        }
        reusableView.viewModel = reusableViewModel

        return reusableView
    }
}

extension HomeHistoryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 99)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width - 24, height: 42)
        }
        return CGSize(width: collectionView.frame.width - 48, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 10
    }
}
