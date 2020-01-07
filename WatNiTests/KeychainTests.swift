//
//  KeychainTests.swift
//  WatNiTests
//
//  Created by 홍창남 on 2020/01/08.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import XCTest
import KeychainAccess
@testable import WatNi

class KeychainProviderMock: KeychainProvidable {

    let keychain = Keychain(service: "com.test.keychainmock")

    func item(for key: KeychainKey) -> Result<String, Error> {
        do {
            guard let value = try keychain.get(key.rawValue) else {
                return .failure(KeychainError.valueFromKeyIsNil)
            }
            return .success(value)
        } catch {
            return .failure(error)
        }
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

class KeychainTests: XCTestCase {
    var keychainProvider = KeychainProviderMock()

    let testEmail = "abc@gmail.com"
    let testToken = "qwr098sd98sg7d8rsrc08sf9d"
    let testPassword = "1284901asr"

    override func setUp() {
        super.setUp()

        keychainProvider.update(testEmail, for: .email)
    }

    override func tearDown() {
        super.tearDown()

        _ = try? keychainProvider.keychain.removeAll()
    }

    func testGetItem() {
        let emailResult = keychainProvider.item(for: .email)

        switch emailResult {
        case .success(let email):
            XCTAssert(email == testEmail, "Strings are different")
        case .failure(let error):
            XCTAssert(false, "Error Occured \(error)")
        }
    }

    func testUpdateItem() {
        keychainProvider.update(testToken, for: .accessToken)

        do {
            let item = try KeychainProvider.default.item(for: .accessToken).get()
            XCTAssertTrue(item == testToken, "values are different")
        } catch {
            XCTAssert(false, "Get Item fails")
        }
    }

    func testRemoveItem() {
        let result = keychainProvider.update(testPassword, for: .password)

        switch result {
        case .success:
            keychainProvider.remove(key: .password)
        case .failure:
            XCTAssert(false, "Update failure")
        }

        let passwordResult = keychainProvider.item(for: .password)
        switch passwordResult {
        case .success:
            XCTAssert(false, "Item is not removed")
        case .failure(let error):
            if case KeychainError.valueFromKeyIsNil = error {
                XCTAssert(true)
                return
            }
            XCTAssert(false, "Unexpected Error \(error)")
        }
    }
}
