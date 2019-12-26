//
//  StringValidationTests.swift
//  CheckThatTests
//
//  Created by 홍창남 on 2019/12/26.
//  Copyright © 2019 hcn1519. All rights reserved.
//

import XCTest
@testable import CheckThat

class StringValidationTests: XCTestCase {

    // MARK: Email Validation

    func testIdentifierValid1() {
        let emailCandidate = "abcded"
        XCTAssertFalse(emailCandidate.isValidEmail(candidate: emailCandidate), "Wrong Email")
    }

    func testIdentifierValid2() {
        let emailCandidate = "a1w124@navercom"
        XCTAssertFalse(emailCandidate.isValidEmail(candidate: emailCandidate), "Wrong Email")
    }

    func testIdentifierValid3() {
        let emailCandidate = "abcded@gmail.com"
        XCTAssert(emailCandidate.isValidEmail(candidate: emailCandidate), "Email should be valid")
    }

    func testIdentifierValid4() {
        let emailCandidate = "ab-c123d.ed@naver.com"
        XCTAssert(emailCandidate.isValidEmail(candidate: emailCandidate), "Email should be valid")
    }

    // MARK: Password Validation

    func testPasswordValid1() {
        let pwCandidate = ""
        XCTAssertFalse(pwCandidate.isValidPassword(candidate: pwCandidate), "Wrong Password")
    }

    func testPasswordValid2() {
        let pwCandidate = "1234567890123"
        XCTAssertFalse(pwCandidate.isValidPassword(candidate: pwCandidate), "Wrong Password")
    }

    func testPasswordValid3() {
        let pwCandidate = "123456"
        XCTAssert(pwCandidate.isValidPassword(candidate: pwCandidate), "Password should be valid")
    }

    func testPasswordValid4() {
        let pwCandidate = "123456sd"
        XCTAssert(pwCandidate.isValidPassword(candidate: pwCandidate), "Password should be valid")
    }
}
