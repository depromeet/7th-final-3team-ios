//
//  UnderlineTextFieldView.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/16.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import Combine

class UnderlineTextFieldView: UIView, HasViewModel {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var assistantLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var underLineHeight: NSLayoutConstraint!

    private var cancelables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        subscribeEvent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        subscribeEvent()
    }

    func subscribeEvent() {
        textField.publisher(for: .editingChanged).sink { [weak self] _ in
            self?.inputDidChanged()
        }.store(in: &cancelables)
    }

    var viewModel: UnderlineTextFieldViewModelProtocol = UnderlineTextFieldViewModel() {
        didSet {
            configure(viewModel: viewModel)
        }
    }

    private func inputDidChanged() {
        if viewModel.inputIsValid {
            underLineView.backgroundColor = UIColor(white: 0, alpha: 0.1)
            underLineHeight.constant = 1
            textField.tintColor = .black
        } else {
            underLineView.backgroundColor = UIColor(decimalRed: 234, green: 28, blue: 0)
            underLineHeight.constant = 2
            textField.tintColor = WNColor.primaryRed
        }
        assistantLabel.text = viewModel.assistantLabelStr
    }

    func configure(viewModel: UnderlineTextFieldViewModelProtocol) {
        inputDidChanged()
        descLabel.text = viewModel.descLabelStr
        descLabel.font = UIFont.spoqaFont(ofSize: viewModel.descLabelFontSize, weight: .regular)
        assistantLabel.font = UIFont.spoqaFont(ofSize: viewModel.assistantLabelFontSize, weight: .regular)

        textField.textContentType = viewModel.inputContentType
        textField.returnKeyType = viewModel.returnKeyType
        textField.keyboardType = viewModel.keyboardType
        textField.isSecureTextEntry = viewModel.isSecureTextEntry
        textField.font = UIFont.spoqaFont(ofSize: viewModel.textFieldFontSize, weight: .regular)
    }
}
