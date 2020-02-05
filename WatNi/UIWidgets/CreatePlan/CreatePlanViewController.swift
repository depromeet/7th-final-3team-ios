//
//  CreatePlanViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/05.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import AloeStackView
import SnapKit

class CreatePlanViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = CreatePlanViewModel

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    var viewModel: CreatePlanViewModel

    let stackView = AloeStackView()
    let titleView = UnderlineTextFieldView()
    let dateView = UnderlineLabelView(frame: .zero)
    let timeView = UnderlineTimeView(frame: .zero)
    let placeView = UnderlineTextFieldView()
    let noticeInputView = NoticeInputView(frame: .zero)

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        return picker
    }()

    let timePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.datePickerMode = .time
        picker.minuteInterval = 5
        return picker
    }()

    required init(viewModel: ViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(stackView)
        stackView.hidesSeparatorsByDefault = true
        stackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(separatorView.snp.bottom)
        }
        titleView.snp.makeConstraints { $0.height.equalTo(77) }
        dateView.snp.makeConstraints { $0.height.equalTo(60) }
        timeView.snp.makeConstraints { $0.height.equalTo(60) }
        placeView.snp.makeConstraints { $0.height.equalTo(77) }

        stackView.addRows([titleView, dateView, datePicker, timeView, timePicker, placeView, noticeInputView])
        stackView.setRowsHidden([datePicker, timePicker], isHidden: true)

        stackView.setTapHandler(forRow: dateView) { [weak self] _ in
            guard let self = self else { return }
            let isHidden = !self.stackView.isRowHidden(self.datePicker)
            self.stackView.setRowHidden(self.datePicker, isHidden: isHidden, animated: !isHidden)
        }
        stackView.setTapHandler(forRow: timeView) { [weak self] _ in
            guard let self = self else { return }
            let isHidden = !self.stackView.isRowHidden(self.timePicker)
            self.stackView.setRowHidden(self.timePicker, isHidden: isHidden, animated: !isHidden)
        }

        stackView.setInset(forRows: [titleView, timeView, placeView],
                           inset: UIEdgeInsets(top: 26, left: 24, bottom: 0, right: 24))
        stackView.setInset(forRows: [dateView, noticeInputView],
                           inset: UIEdgeInsets(top: 6, left: 24, bottom: 0, right: 24))

        noticeInputView.textView.delegate = self
    }

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func submitBtnTapped(_ sender: UIButton) {

    }
}

extension CreatePlanViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        stackView.setContentOffset(CGPoint(x: 0, y: noticeInputView.frame.maxY), animated: true)
    }
}
