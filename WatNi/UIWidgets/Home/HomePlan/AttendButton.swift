//
//  AttendButton.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/18.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit

class AttendButton: UIButton {

    enum AttendState {
        case before
        case available(isEventTime: Bool)
        case finish
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 24
        adjustsImageWhenDisabled = false
    }

    func setupTitle(state: AttendState, dDays: Int?) {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                         .font: UIFont.spoqaFont(ofSize: 15, weight: .bold),
                                                         .kern: 1.25]

        let title = buttonTitle(state: state, dDays: dDays)
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        let image = buttomImage(state: state)

        setImage(image, for: .normal)
        setAttributedTitle(attributedString, for: .normal)
        backgroundColor = buttonBackgroundColor(state: state)

        var buttonAvailable: Bool = false
        if case .available(let submitAvailable) = state {
            buttonAvailable = submitAvailable
        }
        isEnabled = buttonAvailable
    }

    private func buttonTitle(state: AttendState, dDays: Int?) -> String {
        switch state {
        case .before:
            let days = dDays ?? 0
            return "출석 D-\(days)"
        case .available:
            return "왔어요!"
        case .finish:
            return "출석 완료"
        }
    }

    private func buttomImage(state: AttendState) -> UIImage? {
        switch state {
        case .before:
            return nil
        case .available:
            return #imageLiteral(resourceName: "ic_camera")
        case .finish:
            return #imageLiteral(resourceName: "attendFin")
        }
    }

    private func buttonBackgroundColor(state: AttendState) -> UIColor {
        switch state {
        case .before, .finish:
            return UIColor(decimalRed: 34, green: 34, blue: 34, alpha: 0.3)
        case .available:
            return WNColor.primaryRed
        }
    }
}
