//
//  LaunchingTaskWorker.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation

class LaunchingTaskWorker {

    func initialViewController(completionHandler: @escaping (Result<InitialScene, Error>) -> Void) {
        
        MemberAccess.default.refreshToken { [weak self] (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success:
                self?.memberMetaData { result in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    case .success(let memberMeta):
                        MemberManager.shared.update(memberMeta: memberMeta)
                        let scene: InitialScene = memberMeta.group.isEmpty ? .coach : .home
                        completionHandler(.success(scene))
                    }
                }
            }
        }
    }

    func memberMetaData(completionHandler: @escaping (Result<MemberMeta, Error>) -> Void) {
        MemberProvider.memberMeta { (result) in
            switch result {
            case .success(let memberMeta):
                print("[User][조회] \(memberMeta)")
                completionHandler(.success(memberMeta))
            case .failure(let error):
                print("[User][조회] 실패: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
}
