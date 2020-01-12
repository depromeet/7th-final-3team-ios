//
//  KeychainProvider.swift
//  WatNi
//
//  Created by 홍창남 on 2020/01/07.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import Foundation
import KeychainAccess

enum KeychainError: Error {
    case valueFromKeyIsNil
}

protocol KeychainProvidable {
    var keychain: Keychain { get }
    func item(for key: KeychainKey) -> String?
    func update(_ item: String, for key: KeychainKey) -> Result<Void, Error>
    func remove(key: KeychainKey)
}

enum KeychainKey: String {
    case name
    case email
    case password
    case accessToken
    case refreshToken
}

class KeychainProvider: KeychainProvidable {
    static let `default` = KeychainProvider()
    fileprivate init() {}

    let keychain = Keychain(service: "com.depromeet.watni")

    private func item(key: KeychainKey) -> Result<String, Error> {
        do {
            guard let value = try keychain.get(key.rawValue) else {
                return .failure(KeychainError.valueFromKeyIsNil)
            }
            return .success(value)
        } catch {
            return .failure(error)
        }
    }

    func item(for key: KeychainKey) -> String? {
        let result = self.item(key: key)

        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            print("[keychain][\(key.rawValue)] error: \(error.localizedDescription)")
        }
        return nil
    }

    @discardableResult
    func update(_ item: String, for key: KeychainKey) -> Result<Void, Error> {
        do {
            try keychain.set(item, key: key.rawValue)
            return .success(())
        } catch {
            print("[keychain] update error", error)
            return .failure(error)
        }
    }

    func remove(key: KeychainKey) {
        do {
            try keychain.remove(key.rawValue)
        } catch {
            print("[keychain] remove error", error)
        }
    }
}
