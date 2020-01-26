//
//  SignupViewController.swift
//  CheckThat
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Combine

class SignupViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = SignupViewModel

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var nameTextFieldView: UnderlineTextFieldView!
    @IBOutlet private weak var emailTextFieldView: UnderlineTextFieldView!
    @IBOutlet private weak var passwordTextFieldView: UnderlineTextFieldView!
    @IBOutlet private weak var passwordConfirmTextFieldView: UnderlineTextFieldView!

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: SubmitButton!

    let viewModel: SignupViewModel
    private var cancelables = Set<AnyCancellable>()

    required init(viewModel: SignupViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextFieldView.textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextFieldView.textField.delegate = self
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
        passwordConfirmTextFieldView.textField.delegate = self

        indicatorView.isHidden = true
        subscribeTextField()
        subscribeSignUpButton()
    }

    @IBAction func naviBackBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SignupViewController {

    private func subscribeSignUpButton() {
        signUpButton.publisher(for: .touchUpInside).sink { [weak self] (sender) in
            sender.isUserInteractionEnabled = false
            self?.indicatorView.isHidden = false
            self?.indicatorView.startAnimating()
            self?.viewModel.signUp(completionHandler: { (result) in
                defer {
                    sender.isUserInteractionEnabled = true
                    self?.indicatorView.isHidden = true
                    self?.indicatorView.stopAnimating()
                }
                switch result {
                case .failure(let error):
                    let alertController = UIAlertController(title: "회원 가입 실패",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                case .success:
                    let viewModel = CoachViewModel()
                    let coachVC = CoachViewController(viewModel: viewModel, nibName: CoachViewController.className)
                    self?.navigationController?.pushViewController(coachVC, animated: true)
                }
            })
        }.store(in: &cancelables)
    }

    private func subscribeTextField() {
        nameTextFieldView.viewModel = viewModel.createUnderlineViewModel(inputType: .name)
        emailTextFieldView.viewModel = viewModel.createUnderlineViewModel(inputType: .email)
        passwordTextFieldView.viewModel = viewModel.createUnderlineViewModel(inputType: .password)
        passwordConfirmTextFieldView.viewModel = viewModel.createUnderlineViewModel(inputType: .passwordConfirm)

        let namePublisher = nameTextFieldView.textField.publisher(for: .editingChanged)
        let emailPublisher = emailTextFieldView.textField.publisher(for: .editingChanged)
        let passwordPublisher = passwordTextFieldView.textField.publisher(for: .editingChanged)
        let passwordConfirmPublisher = passwordConfirmTextFieldView.textField.publisher(for: .editingChanged)

        namePublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(.name, newValue: input)
            self?.nameTextFieldView.viewModel.inputStr = input
            self?.signUpButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)

        emailPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(.email, newValue: input)
            self?.emailTextFieldView.viewModel.inputStr = input
            self?.signUpButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)

        passwordPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(.password, newValue: input)
            self?.passwordTextFieldView.viewModel.inputStr = input
            self?.signUpButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)

        passwordConfirmPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(.passwordConfirm, newValue: input)
            self?.passwordConfirmTextFieldView.viewModel.inputStr = input
            self?.signUpButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)
    }
}
// MARK: UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextFieldView.textField {
            emailTextFieldView.textField.becomeFirstResponder()
        } else if textField == emailTextFieldView.textField {
            passwordTextFieldView.textField.becomeFirstResponder()
        } else if textField == passwordTextFieldView.textField {
            passwordConfirmTextFieldView.textField.becomeFirstResponder()
        } else if textField == passwordConfirmTextFieldView.textField {
            passwordConfirmTextFieldView.textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordConfirmTextFieldView.textField {
            scrollView.setContentOffset(.zero, animated: true)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextFieldView.textField {
            scrollView.setContentOffset(.zero, animated: true)
        } else if textField == emailTextFieldView.textField || textField == passwordTextFieldView.textField {
            scrollView.setContentOffset(emailTextFieldView.frame.origin, animated: true)
        } else if textField == passwordConfirmTextFieldView.textField {
            scrollView.setContentOffset(passwordTextFieldView.frame.origin, animated: true)
        }
    }
}
