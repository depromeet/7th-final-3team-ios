//
//  SignInViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/11.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Combine

class SignInViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SignInViewModel

    @IBOutlet private weak var emailTextFieldView: UnderlineTextFieldView!
    @IBOutlet private weak var passwordTextFieldView: UnderlineTextFieldView!
    @IBOutlet weak var submitButton: SubmitButton!

    let viewModel: SignInViewModel
    private var cancelables = Set<AnyCancellable>()

    required init(viewModel: SignInViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeTextFieldEditingChanged()
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self

        submitButton.isEnabled = false
    }

    private func subscribeTextFieldEditingChanged() {
        let emailViewModel = UnderlineTextFieldViewModel(descLabelStr: "이메일",
                                                         inputContentType: .emailAddress,
                                                         returnKeyType: .continue,
                                                         keyboardType: .asciiCapable)

        let passwordViewModel = UnderlineTextFieldViewModel(descLabelStr: "비밀번호",
                                                            inputContentType: .password,
                                                            returnKeyType: .done,
                                                            keyboardType: .default)

        emailTextFieldView.viewModel = emailViewModel
        passwordTextFieldView.viewModel = passwordViewModel

        let emailPublisher = emailTextFieldView.textField.publisher(for: .editingChanged)
        let passwordPublisher = passwordTextFieldView.textField.publisher(for: .editingChanged)

        emailPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            emailViewModel.inputStr = input
            let passwordInput = self?.passwordTextFieldView.viewModel.inputStr ?? ""
            self?.submitButton.isEnabled = !input.isEmpty && !passwordInput.isEmpty
        }.store(in: &cancelables)

        passwordPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            passwordViewModel.inputStr = input
            let emailInput = self?.emailTextFieldView.viewModel.inputStr ?? ""
            self?.submitButton.isEnabled = !input.isEmpty && !emailInput.isEmpty
        }.store(in: &cancelables)
    }

    @IBAction func signInBtnTapped(_ sender: UIButton) {

        let email = emailTextFieldView.viewModel.inputStr
        let password = passwordTextFieldView.viewModel.inputStr

        AuthProvider.issueToken(email: email, password: password) { result in
            // TODO: SignUp 작업 이후 로직 구현
            print(result)
        }
    }

    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        let signupViewModel = SignupViewModel()
        let signupVC = SignupViewController(viewModel: signupViewModel,
                                            nibName: SignupViewController.className)
        navigationController?.pushViewController(signupVC, animated: true)
    }

    @IBAction func navigationBackBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextFieldView.textField {
            passwordTextFieldView.textField.becomeFirstResponder()
        } else if textField == passwordTextFieldView.textField {
            passwordTextFieldView.textField.resignFirstResponder()
        }
        return true
    }
}
