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
    @IBOutlet weak var signInButton: SubmitButton!

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

        subscribeSignInButtonTap()
        signInButton.isEnabled = false
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
            self?.viewModel.update(.password, newValue: passwordInput)
            self?.signInButton.isEnabled = !input.isEmpty && !passwordInput.isEmpty
        }.store(in: &cancelables)

        passwordPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            passwordViewModel.inputStr = input
            let emailInput = self?.emailTextFieldView.viewModel.inputStr ?? ""
            self?.viewModel.update(.email, newValue: emailInput)
            self?.signInButton.isEnabled = !input.isEmpty && !emailInput.isEmpty
        }.store(in: &cancelables)
    }

    private func subscribeSignInButtonTap() {
        let email = emailTextFieldView.viewModel.inputStr
        let password = passwordTextFieldView.viewModel.inputStr

        signInButton.publisher(for: .touchUpInside).sink { [weak self] (sender) in
            sender.isUserInteractionEnabled = false
            self?.viewModel.signIn(completionHandler: { result in
                defer {
                    sender.isUserInteractionEnabled = true
                }
                switch result {
                case .failure(let error):
                    let alertController = UIAlertController(title: "로그인 실패",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                case .success:
                    let viewModel = CoachViewModel()
                    let coachVC = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
                    self?.navigationController?.setViewControllers([coachVC], animated: true)
                }
            })
        }.store(in: &cancelables)
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
