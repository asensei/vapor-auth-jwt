//
//  Request+AuthorizableTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 28/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import XCTVapor
import Vapor
@testable import JWTAuth

class RequestAuthorizableTests: XCTVaporTests {

    override func setUp() {
        XCTVapor.app = { Application(.testing) }
        super.setUp()
    }

    func testRequireAuthorizedSubject() {
        let mock = MockAuthorizable(subject: "1234")
        let request = Request(application: self.app, method: .GET, url: "http://localhost", on: self.app.eventLoopGroup.next()).auth
        request.login(mock)

        XCTAssertNoThrow(try request.require(MockAuthorizable.self, subject: "1234"))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, subject: "5678"))
        XCTAssertTrue(request.has(MockAuthorizable.self, subject: "1234"))
        XCTAssertFalse(request.has(MockAuthorizable.self, subject: "5678"))
        XCTAssertNoThrow(try request.require(MockAuthorizable.self, anyOfSubjects: ["1234", "5678"]))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, anyOfSubjects: ["5678", "6789"]))
        XCTAssertTrue(request.has(MockAuthorizable.self, anyOfSubjects: ["1234", "5678"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, anyOfSubjects: ["5678", "6789"]))
    }

    func testRequireAuthorizedSubjectWithUnauthenticatedRequest() {
        let request = Request(application: self.app, method: .GET, url: "http://localhost", on: self.app.eventLoopGroup.next()).auth

        XCTAssertThrowsError(try request.require(MockAuthorizable.self, subject: "1234"))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, anyOfSubjects: ["1234"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, subject: "1234"))
        XCTAssertFalse(request.has(MockAuthorizable.self, anyOfSubjects: ["1234"]))
    }

    func testRequireAuthorizedPermission() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]
        let request = Request(application: self.app, method: .GET, url: "http://localhost", on: self.app.eventLoopGroup.next()).auth
        request.login(mock)

        XCTAssertNoThrow(try request.require(MockAuthorizable.self, permission: "read"))
        XCTAssertNoThrow(try request.require(MockAuthorizable.self, permission: "write"))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, subject: "delete"))
        XCTAssertTrue(request.has(MockAuthorizable.self, permission: "read"))
        XCTAssertFalse(request.has(MockAuthorizable.self, permission: "delete"))
        XCTAssertNoThrow(try request.require(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertTrue(request.has(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertNoThrow(try request.require(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
        XCTAssertTrue(request.has(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
    }

    func testRequireAuthorizedPermissionWithUnauthenticatedRequest() {
        var mock = MockAuthorizable(subject: "1234")
        mock.permissions = ["read", "write"]
        let request = Request(application: self.app, method: .GET, url: "http://localhost", on: self.app.eventLoopGroup.next()).auth

        XCTAssertThrowsError(try request.require(MockAuthorizable.self, permission: "read"))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, permission: "write"))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, subject: "delete"))
        XCTAssertFalse(request.has(MockAuthorizable.self, permission: "read"))
        XCTAssertFalse(request.has(MockAuthorizable.self, permission: "delete"))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, allOfPermissions: ["read", "write"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, allOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertThrowsError(try request.require(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, anyOfPermissions: ["read", "delete"]))
        XCTAssertFalse(request.has(MockAuthorizable.self, anyOfPermissions: ["update", "delete"]))
    }
}
