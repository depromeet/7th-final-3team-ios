//
//  NewbieViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/30.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Combine

class NewbieViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = NewbieViewModelProtocol

    @IBOutlet weak var titleGuideLabel: UILabel!
    @IBOutlet weak var textFieldView: UnderlineTextFieldView!
    @IBOutlet weak var submitButton: SubmitButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    let viewModel: NewbieViewModelProtocol
    private var cancelables = Set<AnyCancellable>()

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldView.textField.delegate = self
        textFieldView.viewModel = viewModel.createUnderlineViewModel()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 37
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.spoqaFont(ofSize: 25, weight: .bold),
                                                        .paragraphStyle: paragraphStyle]
        titleGuideLabel.attributedText = NSAttributedString(string: viewModel.titleGuideText,
                                                            attributes: attributes)
        subscribeTextField()
        submitButton.isEnabled = false
        indicatorView.isHidden = true
        subscribeSubmitButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textFieldView.textField.becomeFirstResponder()
    }

    private func subscribeTextField() {
        let textPublisher = textFieldView.textField.publisher(for: .editingChanged)

        textPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.textFieldView.viewModel.update(.input)
            self?.viewModel.update(input: input)
            self?.textFieldView.viewModel.inputStr = input
            self?.submitButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)
    }

    private func subscribeSubmitButton() {
        submitButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            self?.submitButton.isUserInteractionEnabled = false
            self?.indicatorView.isHidden = false
            self?.indicatorView.startAnimating()

            self?.viewModel.submitAction(completionHandler: { (result) in
                defer {
                    self?.submitButton.isUserInteractionEnabled = true
                    self?.indicatorView.isHidden = true
                    self?.indicatorView.stopAnimating()
                }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.textFieldView.viewModel.responseStr = error.localizedDescription
                    self?.textFieldView.viewModel.update(UnderlineTextFieldViewModel.Mode.response)
                    self?.textFieldView.reloadTextiFieldView()
                case .success(let anyDecodable):

                    guard let group = anyDecodable as? WNGroup else {
                        // 관리자 초대 코드 입력 이후 이동
                        if let groups = anyDecodable as? [WNGroup] {
                            let viewModel = HomeTabPagerViewModel(groups: groups)
                            let homeVC = HomeTabPagerViewController(viewModel: viewModel,
                                                                    nibName: HomeTabPagerViewController.className)
                            self?.navigationController?.setViewControllers([homeVC], animated: false)
                        }
                        return
                    }

                    // 초대 코드 생성 화면으로 이동
                    let createGroupViewModel = CreateGroupCodeViewModel(group: group)
                    let viewController = NewbieViewController(viewModel: createGroupViewModel,
                                                              nibName: NewbieViewController.className)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            })
        }.store(in: &cancelables)
    }

    @IBAction func navigationBackBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension NewbieViewController: UITextFieldDelegate {

}
