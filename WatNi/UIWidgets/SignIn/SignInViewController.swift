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
        }.assign(to: \UnderlineTextFieldViewModel.inputStr, on: emailViewModel)
            .store(in: &cancelables)

        passwordPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.assign(to: \UnderlineTextFieldViewModel.inputStr, on: passwordViewModel)
            .store(in: &cancelables)
    }

    @IBAction func signInBtnTapped(_ sender: UIButton) {

        AuthProvider.issueToken(userName: "test@naver.com", password: "test") { result in
            print(result)
        }
    }
}

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
