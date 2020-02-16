//
//  HomePlanViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/02.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomePlanViewController: UIViewController, ViewModelInjectable, HomeTabViewController {

    typealias ViewModel = HomePlanViewModel

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var managerEmptyView: UIStackView!
    @IBOutlet weak var participantEmptyView: UIStackView!

    let viewModel: HomePlanViewModel

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

        collectionView.register(headers: [HomePlanCollectionReusableView.self])
        collectionView.register(cells: [HomePlanCollectionViewCell.self])
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false

        collectionView.isHidden = viewModel.shouldHideCollectionView
        managerEmptyView.isHidden = viewModel.shouldHideManagerEmptyView
        participantEmptyView.isHidden = viewModel.shouldHideParticipantEmptyView
    }

    @IBAction func createPlanBtnTapped(_ sender: UIButton) {
        guard let group = viewModel.userGroups.first else { return }

        let viewModel = CreatePlanViewModel(group: group)
        let createPlanVC = CreatePlanViewController(viewModel: viewModel,
                                                    nibName: CreatePlanViewController.className)
        let navigationController = UINavigationController(rootViewController: createPlanVC)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension HomePlanViewController: UICollectionViewDataSource {
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
        guard let reusableViewModel = viewModel.reusableViewModel(sectionType: .plan),
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

// MARK: UICollectionViewDelegateFlowLayout
extension HomePlanViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 48
        let height = viewModel.cellHeight(cellWidth: width, indexPath: indexPath)
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 99)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
