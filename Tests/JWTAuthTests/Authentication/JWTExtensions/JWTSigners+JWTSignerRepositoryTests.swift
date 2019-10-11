//
//  JWTSigners+JWTSignerRepositoryTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import JWT
import Service
@testable import JWTAuth

class JWTSignersJWTSignerRepositoryTests: XCTestCase {

    func testGetValidKid() throws {
        let signer = JWTSigner.hs256(key: Data("secret".utf8))
        let signers = JWTSigners()
        signers.use(signer, kid: "1234")

        let fetchedSigner = try signers.get(kid: "1234", on: BasicContainer.mock).wait()

        XCTAssertTrue(signer === fetchedSigner)
    }

    func testGetInvalidKid() {
        let signers = JWTSigners()
        XCTAssertThrowsError(try signers.get(kid: "1234", on: BasicContainer.mock).wait())
    }

    func testMakeService() {
        var services = Services()
        services.register(JWTSigners.self)

        let container = BasicContainer(
            config: Config(),
            environment: .testing,
            services: services,
            on: EmbeddedEventLoop()
        )

        XCTAssertNoThrow(try container.make(JWTSigners.self))
    }
}
