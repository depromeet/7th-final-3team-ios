//
//  CreatePlanViewModel.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/06.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Photos

class CreatePlanViewModel {

    func photoErrorMessage(error: PHPhotoLibrary.PhotoError) -> String {
        switch error {
        case .restricted:
            return "사진 접근에 제약이 있습니다."
        case .denied:
            return "앱 설정에서 사진 접근을 허용해주세요."
        }
    }

    func authStatus(completion: @escaping (Result<Void, PHPhotoLibrary.PhotoError>) -> Void) {
        PHPhotoLibrary.authStatus { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
