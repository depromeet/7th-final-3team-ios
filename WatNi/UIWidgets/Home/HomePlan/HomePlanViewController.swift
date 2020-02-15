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
        guard let group = viewModel.groups.first else { return }

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
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePlanCollectionViewCell.className,
                                                      for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: HomePlanCollectionReusableView.className,
                                                                     for: indexPath)
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomePlanViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 48, height: 479)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 99)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
