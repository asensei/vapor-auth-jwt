//
//  JWTAuthenticationMiddlewareTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 18/09/2017.
//  Copyright © 2017 Asensei Inc. All rights reserved.
//

import XCTest
import Authentication
import Vapor
import HTTP
import JWT
@testable import JWTAuth

class JWTAuthenticationMiddlewareTests: XCTestCase {

    static let allTests = [
        ("testRespond", testRespond),
        ("testRespondWithError", testRespondWithError)
    ]

    func testRespond() throws {

        let signer = JWTSigner.hs256(key: Data("secret".utf8))
        let signers = JWTSigners()
        signers.use(signer, kid: "1234")
        let jwt = JWT(header: .init(kid: "1234"), payload: MockPayload())
        let signatureData = try jwt.sign(using: signer)
        let signature = String(bytes: signatureData, encoding: .utf8)!

        let request = Request(
            http: .init(
                method: .GET,
                url: "http://localhost/test",
                headers: .init([("Authorization", "Bearer \(signature)")])
            ),
            using: self.mockContainer()
        )

        let middleware = JWTAuthenticationMiddleware(MockPayload.self, signers: signers)
        let responder = MockResponder(response: Response(http: .init(status: .continue), using: request))
        let response = try middleware.respond(to: request, chainingTo: responder).wait()

        XCTAssertEqual(response.http.status, .continue)
        XCTAssertTrue(try request.isAuthenticated(MockPayload.self))
    }

    func testRespondWithError() throws {

        let signer = JWTSigner.hs256(key: Data("secret".utf8))
        let signers = JWTSigners()
        signers.use(signer, kid: "1234")

        let request = Request(
            http: .init(
                method: .GET,
                url: "http://localhost/test"
            ),
            using: self.mockContainer()
        )

        let middleware = JWTAuthenticationMiddleware(MockPayload.self, signers: signers)
        let responder = MockResponder(response: Response(http: .init(status: .continue), using: request))

        XCTAssertNoThrow(try middleware.respond(to: request, chainingTo: responder).wait())
        XCTAssertFalse(try request.isAuthenticated(MockPayload.self))
    }
}

extension JWTAuthenticationMiddlewareTests {

    struct MockResponder: Responder {

        var response: Response

        func respond(to request: Request) throws -> Future<Response> {
            return BasicContainer.mock.eventLoop.newSucceededFuture(result: self.response)
        }
    }

    func mockContainer() -> Container {
        var services = Services.default()
        try! services.register(AuthenticationProvider())

        return BasicContainer(
            config: Config(),
            environment: .testing,
            services: services,
            on: EmbeddedEventLoop()
        )
    }
}
