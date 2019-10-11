//
//  Request+AuthorizableTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 28/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import Vapor
@testable import JWTAuth

class RequestAuthorizableTests: XCTestCase {

    func testRequireAuthorizedSubject() {
        let mock = MockAuthorizable(subject: "1234")
        let request = Request(http: .init(method: .GET, url: "http://localhost"), using: BasicContainer.mock)

        XCTAssertNoThrow(try request.authenticate(mock))
        XCTAssertNoThrow(try request.requireAuthorized(MockAuthorizable.self, subject: "1234"))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, subject: "5678"))
        XCTAssertTrue(request.isAuthorized(MockAuthorizable.self, subject: "1234"))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, subject: "5678"))
        XCTAssertNoThrow(try request.requireAuthorized(MockAuthorizable.self, anyOfSubjects: ["1234", "5678"]))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, anyOfSubjects: ["5678", "6789"]))
        XCTAssertTrue(request.isAuthorized(MockAuthorizable.self, anyOfSubjects: ["1234", "5678"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, anyOfSubjects: ["5678", "6789"]))
    }

    func testRequireAuthorizedSubjectWithUnauthenticatedRequest() {
        let request = Request(http: .init(method: .GET, url: "http://localhost"), using: BasicContainer.mock)

        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, subject: "1234"))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, anyOfSubjects: ["1234"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, subject: "1234"))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, anyOfSubjects: ["1234"]))
    }

    func testRequireAuthorizedPermission() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]
        let request = Request(http: .init(method: .GET, url: "http://localhost"), using: BasicContainer.mock)

        XCTAssertNoThrow(try request.authenticate(mock))
        XCTAssertNoThrow(try request.requireAuthorized(MockAuthorizable.self, permission: "read"))
        XCTAssertNoThrow(try request.requireAuthorized(MockAuthorizable.self, permission: "write"))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, subject: "delete"))
        XCTAssertTrue(request.isAuthorized(MockAuthorizable.self, permission: "read"))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, permission: "delete"))
        XCTAssertNoThrow(try request.requireAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertTrue(request.isAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertNoThrow(try request.requireAuthorized(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
        XCTAssertTrue(request.isAuthorized(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
    }

    func testRequireAuthorizedPermissionWithUnauthenticatedRequest() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]
        let request = Request(http: .init(method: .GET, url: "http://localhost"), using: BasicContainer.mock)

        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, permission: "read"))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, permission: "write"))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, subject: "delete"))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, permission: "read"))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, permission: "delete"))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try request.requireAuthorized(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertFalse(request.isAuthorized(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
    }
}
