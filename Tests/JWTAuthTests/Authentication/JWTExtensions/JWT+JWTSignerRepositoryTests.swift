//
//  JWT+JWTSignerRepositoryTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import JWT
import Service
@testable import JWTAuth

class JWTJWTSignerRepositoryTests: XCTestCase {

    func testDataWithValidSignature() throws {
        let signer = JWTSigner.hs256(key: Data("secret".utf8))
        let signers = JWTSigners()
        signers.use(signer, kid: "1234")
        let jwt = JWT(header: .init(kid: "1234"), payload: MockPayload())
        let signature = try jwt.sign(using: signer)
        let container = BasicContainer.mock

        let verifiedPayload = try JWT<MockPayload>.data(signature, verifiedUsing: signers, on: container).wait().payload

        XCTAssertEqual(verifiedPayload, jwt.payload)
    }
}
