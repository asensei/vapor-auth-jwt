//
//  SubjectAuthorizableTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 28/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
@testable import JWTAuth

class SubjectAuthorizableTests: XCTestCase {

    func testIsAuthorized() {
        let mock = MockAuthorizable(subject: "1234")

        XCTAssertTrue(mock.has(subject: "1234"))
        XCTAssertFalse(mock.has(subject: "5678"))
    }

    func testRequireAuthorizedAnyOf() {
        let mock = MockAuthorizable(subject: "1234")

        XCTAssertThrowsError(try mock.require(anyOfSubjects: nil))
        XCTAssertThrowsError(try mock.require(anyOfSubjects: []))
        XCTAssertNoThrow(try mock.require(anyOfSubjects: ["1234", "5678"]))
        XCTAssertThrowsError(try mock.require(anyOfSubjects: ["6789", "5678"]))
        XCTAssertTrue(mock.has(anyOfSubjects: ["1234", "5678"]))
        XCTAssertFalse(mock.has(anyOfSubjects: ["6789", "5678"]))
    }
}
