//
//  WNAlertViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import AloeStackView
import SnapKit

class WNAlertController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!

    let aloeStackView = AloeStackView()

    let alertTitle: String?
    let message: String?
    let style: UIAlertController.Style
    private var actions: [WNAlertAction] = []
    private var isFirstLayoutSubViews: Bool = true

    private let messageHeight: CGFloat = 47
    private let buttonHeight: CGFloat = 56

    var didTapBackground: (() -> Void)?

    required init(title: String?, message: String?, style: UIAlertController.Style) {
        self.alertTitle = title
        self.message = message
        self.style = style
        super.init(nibName: WNAlertController.className, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(aloeStackView)

        aloeStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(stackViewHeight)
        }
        aloeStackView.separatorInset = .zero
        aloeStackView.separatorColor = UIColor(decimalRed: 34, green: 34, blue: 34, alpha: 0.1)

        setupMessage()
        actions.forEach { action in
            self.setupButton(action: action)
        }
    }

    var stackViewHeight: CGFloat {
        let buttonHeight: CGFloat = CGFloat(actions.count * 56)

        if message != nil {
            return buttonHeight + 47 + 54
        } else {
            return buttonHeight + 54
        }
    }

    func addActions(_ actions: [WNAlertAction]) {
        self.actions.append(contentsOf: actions)
    }

    private func setupMessage() {
        guard let message = message else {
            return
        }

        switch style {
        case .actionSheet:
            let messageLabel = UILabel(frame: .zero)
            messageLabel.font = UIFont.spoqaFont(ofSize: 15, weight: .regular)
            messageLabel.text = message
            messageLabel.textColor = UIColor(white: 0, alpha: 0.3)
            messageLabel.textAlignment = .center
            aloeStackView.addRow(messageLabel)
            aloeStackView.setInset(forRow: messageLabel, inset: .zero)
            messageLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
                $0.height.equalTo(messageHeight)
            }
        case .alert:
            fatalError("미작업")
        @unknown default:
            fatalError("미작업")
        }
    }

    private func setupButton(action: WNAlertAction) {
        switch style {
        case .actionSheet:
            let actionButton = WNActionButton(frame: .zero)
            actionButton.setTitle(action.title, for: .normal)
            aloeStackView.addRow(actionButton)
            aloeStackView.setInset(forRow: actionButton, inset: .zero)
            actionButton.snp.makeConstraints {
                $0.height.equalTo(buttonHeight)
            }
        case .alert:
            fatalError("미작업")
        @unknown default:
            fatalError("미작업")
        }

    }

    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        didTapBackground?()
    }
}
