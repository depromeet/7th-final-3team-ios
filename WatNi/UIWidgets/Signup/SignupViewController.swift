//
//  SignupViewController.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SignupViewModel

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    let viewModel: SignupViewModel

    required init(viewModel: SignupViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func emailDidChanged(_ sender: UITextField) {
        viewModel.email = sender.text ?? ""
    }

    @IBAction func passwordDidChanged(_ sender: UITextField) {
        viewModel.password = sender.text ?? ""
    }

    @IBAction func passwordConfirmDidChanged(_ sender: UITextField) {
        viewModel.passwordConfirm = sender.text ?? ""
    }
}
