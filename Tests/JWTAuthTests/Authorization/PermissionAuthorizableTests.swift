//
//  PermissionAuthorizableTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 28/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
@testable import JWTAuth

class PermissionAuthorizableTests: XCTestCase {

    func testIsAuthorized() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]

        XCTAssertTrue(mock.has(permission: "read"))
        XCTAssertTrue(mock.has(permission: "write"))
        XCTAssertFalse(mock.has(permission: "delete"))
    }

    func testRequireAuthorizedAllOf() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]

        XCTAssertNoThrow(try mock.require(allOfPermissions: []))
        XCTAssertNoThrow(try mock.require(allOfPermissions: ["read", "write"]))
        XCTAssertThrowsError(try mock.require(allOfPermissions: ["read", "delete"]))
        XCTAssertTrue(mock.has(allOfPermissions: ["read", "write"]))
        XCTAssertFalse(mock.has(allOfPermissions: ["read", "delete"]))
    }

    func testRequireAuthorizedAnyOf() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]

        XCTAssertNoThrow(try mock.require(anyOfPermissions: []))
        XCTAssertNoThrow(try mock.require(anyOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try mock.require(anyOfPermissions: ["update", "delete"]))
        XCTAssertTrue(mock.has(anyOfPermissions: ["read", "delete"]))
        XCTAssertFalse(mock.has(anyOfPermissions: ["update", "delete"]))
    }
}
