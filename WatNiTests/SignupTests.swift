//
//  SignupTests.swift
//  CheckThatTests
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import XCTest
@testable import WatNi

class SignupTests: XCTestCase {

    var viewModel: SignupViewModel!

    override func setUp() {
        viewModel = SignupViewModel()
    }

    // MARK: Email Validation

    func testIdentifierValid1() {
        viewModel.email = "abcded"
        XCTAssertFalse(viewModel.isValidEmail, "Wrong Email")
    }

    func testIdentifierValid2() {
        viewModel.email = "a1w124@navercom"
        XCTAssertFalse(viewModel.isValidEmail, "Wrong Email")
    }

    func testIdentifierValid3() {
        viewModel.email = "abcded@gmail.com"
        XCTAssert(viewModel.isValidEmail, "Email should be valid")
    }

    func testIdentifierValid4() {
        viewModel.email = "ab-c123d.ed@naver.com"
        XCTAssert(viewModel.isValidEmail, "Email should be valid")
    }

    // MARK: Password Validation

    func testPasswordValid1() {
        viewModel.password = ""
        XCTAssertFalse(viewModel.isValidPassword, "Wrong Password")
    }

    func testPasswordValid2() {
        viewModel.password = "1234567890123"
        XCTAssertFalse(viewModel.isValidPassword, "Wrong Password")
    }

    func testPasswordValid3() {
        viewModel.password = "123456"
        XCTAssert(viewModel.isValidPassword, "Password should be valid")
    }

    func testPasswordValid4() {
        viewModel.password = "123456sd"
        XCTAssert(viewModel.isValidPassword, "Password should be valid")
    }
}
