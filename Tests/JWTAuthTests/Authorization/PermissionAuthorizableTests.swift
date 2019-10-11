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

        XCTAssertTrue(mock.isAuthorized(permission: "read"))
        XCTAssertTrue(mock.isAuthorized(permission: "write"))
        XCTAssertFalse(mock.isAuthorized(permission: "delete"))
    }

    func testRequireAuthorizedAllOf() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]

        XCTAssertNoThrow(try mock.requireAuthorized(allOfPermissions: []))
        XCTAssertNoThrow(try mock.requireAuthorized(allOfPermissions: ["read", "write"]))
        XCTAssertThrowsError(try mock.requireAuthorized(allOfPermissions: ["read", "delete"]))
        XCTAssertTrue(mock.isAuthorized(allOfPermissions: ["read", "write"]))
        XCTAssertFalse(mock.isAuthorized(allOfPermissions: ["read", "delete"]))
    }

    func testRequireAuthorizedAnyOf() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]

        XCTAssertNoThrow(try mock.requireAuthorized(anyOfPermissions: []))
        XCTAssertNoThrow(try mock.requireAuthorized(anyOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try mock.requireAuthorized(anyOfPermissions: ["update", "delete"]))
        XCTAssertTrue(mock.isAuthorized(anyOfPermissions: ["read", "delete"]))
        XCTAssertFalse(mock.isAuthorized(anyOfPermissions: ["update", "delete"]))
    }
}
