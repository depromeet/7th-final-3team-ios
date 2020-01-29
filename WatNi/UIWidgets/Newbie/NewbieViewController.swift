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

    typealias ViewModel = NewbieViewModel

    @IBOutlet weak var titleGuideLabel: UILabel!
    @IBOutlet weak var textFieldView: UnderlineTextFieldView!
    @IBOutlet weak var submitButton: SubmitButton!

    let viewModel: NewbieViewModel
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
