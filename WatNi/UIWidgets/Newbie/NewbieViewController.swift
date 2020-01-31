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
        submitButton.publisher(for: .touchUpInside).sink { [weak self] _ in

            self?.viewModel.submitAction(completionHandler: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let anyDecodable):

                    guard let group = anyDecodable as? WNGroup else {
                        // TODO: 홈으로 이동
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textFieldView.textField.becomeFirstResponder()
    }

    private func subscribeTextField() {
        let textPublisher = textFieldView.textField.publisher(for: .editingChanged)

        textPublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(input: input)
            self?.textFieldView.viewModel.inputStr = input
            self?.submitButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)
    }

    @IBAction func navigationBackBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension NewbieViewController: UITextFieldDelegate {

}
