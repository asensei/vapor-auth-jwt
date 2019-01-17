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

    static let allTests = [
        ("testIsAuthorized", testIsAuthorized),
        ("testRequireAuthorizedAnyOf", testRequireAuthorizedAnyOf)
    ]

    func testIsAuthorized() {
        let mock = MockAuthorizable(subject: "1234")

        XCTAssertTrue(mock.isAuthorized(subject: "1234"))
        XCTAssertFalse(mock.isAuthorized(subject: "5678"))
    }

    func testRequireAuthorizedAnyOf() {
        let mock = MockAuthorizable(subject: "1234")

        XCTAssertThrowsError(try mock.requireAuthorized(anyOfSubjects: nil))
        XCTAssertThrowsError(try mock.requireAuthorized(anyOfSubjects: []))
        XCTAssertNoThrow(try mock.requireAuthorized(anyOfSubjects: ["1234", "5678"]))
        XCTAssertThrowsError(try mock.requireAuthorized(anyOfSubjects: ["6789", "5678"]))
        XCTAssertTrue(mock.isAuthorized(anyOfSubjects: ["1234", "5678"]))
        XCTAssertFalse(mock.isAuthorized(anyOfSubjects: ["6789", "5678"]))
    }
}
