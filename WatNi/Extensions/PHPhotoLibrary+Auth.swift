//
//  PHPhotoLibrary+Auth.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/09.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import Photos

extension PHPhotoLibrary {

    enum PhotoError: Error {
        case denied, restricted
    }

    static func authStatus(completion: @escaping (Result<Void, PhotoError>) -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                switch newStatus {
                case .authorized:
                    completion(.success(()))
                case .denied:
                    completion(.failure(.denied))
                default:
                    completion(.failure(.restricted))
                }
            })
        case .restricted:
            completion(.failure(.restricted))
        case .denied:
            completion(.failure(.denied))
        case .authorized:
            completion(.success(()))
        @unknown default:
            completion(.failure(.restricted))
        }
    }
}
