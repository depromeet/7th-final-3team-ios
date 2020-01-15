//
//  UIControl+CombineCompatible.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/13.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol CombineCompatible {

}

extension UIControl: CombineCompatible {

}

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}
