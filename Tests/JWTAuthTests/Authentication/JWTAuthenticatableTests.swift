//
//  JWTAuthenticatableTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import JWT
import Service
@testable import JWTAuth

class JWTAuthenticatableTests: XCTestCase {

    func testAuthenticate() throws {
        let signer = JWTSigner.hs256(key: Data("secret".utf8))
        let signers = JWTSigners()
        signers.use(signer, kid: "1234")
        let jwt = JWT(header: .init(kid: "1234"), payload: MockPayload())
        let signature = try jwt.sign(using: signer)

        let authenticatedPayload = try MockPayload.authenticate(using: signature, signers: signers, on: BasicContainer.mock).wait()

        XCTAssertNotNil(authenticatedPayload)
        XCTAssertEqual(authenticatedPayload, jwt.payload)
    }
}
