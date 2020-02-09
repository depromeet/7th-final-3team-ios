//
//  ImagePickerAccess.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/09.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import UIKit
import Photos

final class ImagePickerAccess: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?

    var didCancel: (() -> Void)?
    var didSelectImage: ((_ image: UIImage?) -> Void)?

    init(presentationController: UIViewController?, sourceType: UIImagePickerController.SourceType) {

        let availableSourceType: UIImagePickerController.SourceType
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            availableSourceType = sourceType
        } else {
            availableSourceType = .photoLibrary
        }

        let pickerController = UIImagePickerController()
        pickerController.sourceType = availableSourceType
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        self.pickerController = pickerController

        super.init()
        self.presentationController = presentationController
        self.pickerController.delegate = self
    }

    func present() {
        self.presentationController?.present(pickerController, animated: true, completion: nil)
    }
}

extension ImagePickerAccess: UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        didCancel?()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            didSelectImage?(nil)
            return
        }

        picker.dismiss(animated: true, completion: nil)
        didSelectImage?(image)
    }
}

extension ImagePickerAccess: UINavigationControllerDelegate {

}
