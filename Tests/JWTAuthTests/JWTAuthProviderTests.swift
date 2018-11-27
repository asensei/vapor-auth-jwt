//
//  JWTAuthProviderTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import Vapor
@testable import JWTAuth

class JWTAuthProviderTests: XCTestCase {

    static let allTests = [
        ("testBoot", testBoot)
    ]

    func testBoot() throws {

        var services = Services()
        XCTAssertNoThrow(try services.register(JWTAuthProvider()))

        let jwksSignerRepositoryConfig = try JWKSSignerRepository.Config(environment: [
            "JWTAUTH_JWKS_URL": "http://localhost/well-known/jwks.json"
            ])

        services.register(jwksSignerRepositoryConfig)

        let application = try Application(config: Config(), environment: .testing, services: services)

        XCTAssertTrue(application.providers.contains(where: { $0 is JWTAuthProvider }))
        XCTAssertNoThrow(try application.make(JWKSSignerRepository.Config.self))
        XCTAssertNoThrow(try application.make(JWKSSignerRepository.self))
    }
}
