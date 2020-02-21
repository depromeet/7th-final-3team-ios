//
//  SideMenuViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/21.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class SideMenuViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SideMenuViewModel

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var managerLabel: UILabel!
    @IBOutlet private weak var createPlanButton: UIButton!

    @IBOutlet weak var registerHeightConstraint: NSLayoutConstraint!

    let viewModel: SideMenuViewModel

    var didTapCreatePlanButton: (() -> Void)?
    var didTapLogoutButton: (() -> Void)?

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

        managerLabel.text = viewModel.managerStr
        nameLabel.text = viewModel.nameStr
        emailLabel.text = viewModel.emailStr

        // TODO: 데모용, 추후 제거
        if !viewModel.isManager {
            createPlanButton.isHidden = true
            registerHeightConstraint.constant = 0
        }
    }

    @IBAction func createPlanBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: { [weak self] in
            self?.didTapCreatePlanButton?()
        })
    }

    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: { [weak self] in
            self?.didTapLogoutButton?()
        })
    }
}
