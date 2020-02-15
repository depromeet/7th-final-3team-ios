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
import Photos
import Combine

class CreatePlanViewController: UIViewController, ViewModelInjectable {

    typealias ViewModel = CreatePlanViewModel

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!

    let viewModel: CreatePlanViewModel
    private var imagePickerAccess: ImagePickerAccess?
    var cancelables = Set<AnyCancellable>()

    let stackView = AloeStackView()
    let titleView = UnderlineTextFieldView()
    let dateView = UnderlineLabelView(frame: .zero)
    let timeView = UnderlineTimeView(frame: .zero)
    let placeView = UnderlineTextFieldView()
    let noticeInputView = NoticeInputView(frame: .zero)
    let imageInputView = ImageInputView(frame: .zero)

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
        self.navigationController?.navigationBar.isHidden = true

        stackView.hidesSeparatorsByDefault = true
        stackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(separatorView.snp.bottom)
        }
        titleView.snp.makeConstraints { $0.height.equalTo(77) }
        dateView.snp.makeConstraints { $0.height.equalTo(60) }
        timeView.snp.makeConstraints { $0.height.equalTo(60) }
        placeView.snp.makeConstraints { $0.height.equalTo(77) }

        stackView.addRows([titleView, dateView, datePicker, timeView, timePicker, placeView, noticeInputView, imageInputView])
        stackView.setRowsHidden([datePicker, timePicker], isHidden: true)

        stackView.setTapHandler(forRow: dateView) { [weak self] _ in
            guard let self = self else { return }
            let isHidden = !self.stackView.isRowHidden(self.datePicker)
            self.stackView.setRowHidden(self.datePicker, isHidden: isHidden, animated: !isHidden)
        }

        timeView.didTapFromLabel = { [weak self] in
            guard let self = self else { return }
            guard let type = self.viewModel.selectedTimePicker else {
                self.viewModel.selectedTimePicker = .fromTime
                self.timePicker.setDate(self.viewModel.fromTime, animated: false)
                self.stackView.setRowHidden(self.timePicker, isHidden: false, animated: true)
                return
            }

            switch type {
            case .fromTime:
                self.viewModel.selectedTimePicker = nil
                self.stackView.setRowHidden(self.timePicker, isHidden: true, animated: false)
            case .toTime:
                self.viewModel.selectedTimePicker = .fromTime
                self.timePicker.setDate(self.viewModel.fromTime, animated: false)
            }
        }

        timeView.didTapToLabel = { [weak self] in
            guard let self = self else { return }
            guard let type = self.viewModel.selectedTimePicker else {
                self.viewModel.selectedTimePicker = .toTime
                self.timePicker.setDate(self.viewModel.toTime, animated: false)
                self.stackView.setRowHidden(self.timePicker, isHidden: false, animated: true)
                return
            }

            switch type {
            case .fromTime:
                self.viewModel.selectedTimePicker = .toTime
                self.timePicker.setDate(self.viewModel.toTime, animated: false)
            case .toTime:
                self.viewModel.selectedTimePicker = nil
                self.stackView.setRowHidden(self.timePicker, isHidden: true, animated: false)
            }
        }

        stackView.setTapHandler(forRow: imageInputView) { [weak self] (_) in
            self?.setupActionHandler()
        }

        stackView.setInset(forRows: [titleView, timeView, placeView, imageInputView],
                           inset: UIEdgeInsets(top: 26, left: 24, bottom: 0, right: 24))
        stackView.setInset(forRows: [dateView, noticeInputView],
                           inset: UIEdgeInsets(top: 6, left: 24, bottom: 0, right: 24))

        noticeInputView.textView.delegate = self
        submitButton.isEnabled = false
        setupDefaultDateLabel()
        setupViewModels()
    }

    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func submitBtnTapped(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false

        viewModel.createPlan { [weak self] (result) in
            defer {
                sender.isUserInteractionEnabled = true
            }
            switch result {
            case .failure(let error):
                let alertController = UIAlertController(title: "일정 생성 실패",
                                                        message: error.userMessage,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            case .success:
                break
            }
        }
    }

    private func setupDefaultDateLabel() {
        dateView.titleLabel.text = viewModel.defaultValue(.date)
        timeView.fromTimeLabel.text = viewModel.defaultValue(.time(.fromTime))
        timeView.toTimeLabel.text = viewModel.defaultValue(.time(.toTime))
    }

    private func setupViewModels() {
        titleView.viewModel = UnderlineTextFieldViewModel(descLabelStr: "제목")
        placeView.viewModel = UnderlineTextFieldViewModel(descLabelStr: "장소")

        let titlePublisher = titleView.textField.publisher(for: .editingChanged)
        let placePublisher = placeView.textField.publisher(for: .editingChanged)

        titlePublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(.title, newValue: input)
            self?.submitButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)

        placePublisher.compactMap {
            ($0 as? UITextField)?.text
        }.sink { [weak self] (input) in
            self?.viewModel.update(.place, newValue: input)
            self?.submitButton.isEnabled = self?.viewModel.submitAvailable ?? false
        }.store(in: &cancelables)

        datePicker.publisher(for: .valueChanged).compactMap {
            ($0 as? UIDatePicker)?.date
        }.sink { [weak self] (inputDate) in
            let dateStr = self?.viewModel.dateFormatter(for: .date).string(from: inputDate) ?? ""
            self?.dateView.titleLabel.text = dateStr
            self?.viewModel.update(.date, newValue: inputDate)
        }.store(in: &cancelables)

        timePicker.publisher(for: .valueChanged).compactMap {
            ($0 as? UIDatePicker)?.date
        }.sink { [weak self] (inputTime) in

            guard let type = self?.viewModel.selectedTimePicker,
                let timeStr = self?.viewModel.dateFormatter(for: .time).string(from: inputTime) else {
                return
            }

            switch type {
            case .fromTime:
                self?.viewModel.update(.time(.fromTime), newValue: inputTime)
                self?.timeView.fromTimeLabel.text = timeStr
            case .toTime:
                self?.viewModel.update(.time(.toTime), newValue: inputTime)
                self?.timeView.toTimeLabel.text = timeStr
            }
        }.store(in: &cancelables)
    }

    private func setupActionHandler() {
        let alertController = WNAlertController(title: nil, message: "인증샷 예시 올리기", style: .actionSheet)
        alertController.modalPresentationStyle = .pageSheet

        let albumAction = WNAlertAction(title: "앨범", handler: { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.presentImagePicker(sourceType: .photoLibrary)
            })
        })

        let cameraAction = WNAlertAction(title: "카메라", handler: { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.presentImagePicker(sourceType: .camera)
            })
        })

        alertController.addActions([albumAction, cameraAction])
        alertController.didTapBackground = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        navigationController?.present(alertController, animated: true, completion: nil)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        viewModel.authStatus { [weak self] (result) in
            switch result {
            case .success:
                self?.imagePickerAccess = ImagePickerAccess(presentationController: self, sourceType: sourceType)
                self?.imagePickerAccess?.didSelectImage = { [weak self] image in
                    self?.imageInputView.imageView.image = image
                }
                self?.imagePickerAccess?.present()
            case .failure(let error):
                let errorMessage = self?.viewModel.photoErrorMessage(error: error) ?? ""
                let alert = UIAlertController(title: "사진 접근 실패", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CreatePlanViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        stackView.setContentOffset(CGPoint(x: 0, y: noticeInputView.frame.maxY), animated: true)
    }
}
