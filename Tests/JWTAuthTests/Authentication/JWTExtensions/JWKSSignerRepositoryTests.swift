//
//  JWKSSignerRepositoryTests.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import XCTest
import JWT
import Vapor
@testable import JWTAuth

class JWKSSignerRepositoryTests: XCTestCase {

    func testGetValidKid() throws {
        let privateSigner = try JWTSigner.jwk(key: JSONDecoder().decode(JWK.self, from: JWKSSignerRepositoryTests.privateJWK))
        let signers = JWKSSignerRepository(jwksURL: "http://localhost/well-known/jwks.json")
        let container = self.mockContainer()
        let client = try container.make(Client.self) as! MockClient

        client.send = { request in
            XCTAssertEqual(request.http.urlString, "http://localhost/well-known/jwks.json")

            return request.future(request.response(JWKSSignerRepositoryTests.publicJWKS, as: .json))
        }

        let publicSigner = try signers.get(kid: "1234", on: container).wait()

        let jwt = JWT(header: .init(kid: "1234"), payload: MockPayload())
        let signed = try jwt.sign(using: privateSigner)

        XCTAssertEqual(try JWT(from: signed, verifiedUsing: privateSigner).payload, jwt.payload)
        XCTAssertEqual(try JWT(from: signed, verifiedUsing: publicSigner).payload, jwt.payload)
    }

    func testGetInvalidKid() throws {
        let signers = JWKSSignerRepository(jwksURL: "http://localhost/well-known/jwks.json")
        let container = self.mockContainer()
        let client = try container.make(Client.self) as! MockClient

        client.send = { request in
            XCTAssertEqual(request.http.urlString, "http://localhost/well-known/jwks.json")

            return request.future(request.response(JWKSSignerRepositoryTests.publicJWKS, as: .json))
        }

        XCTAssertThrowsError(try signers.get(kid: "5678", on: container).wait())
    }

    func testMakeService() throws {

        let config = try JWKSSignerRepository.Config(environment: [
            "JWTAUTH_JWKS_URL": "http://localhost/well-known/jwks.json"
            ])

        var services = Services()
        services.register(config)
        services.register(JWKSSignerRepository.self)

        let container = BasicContainer(
            config: Config(),
            environment: .testing,
            services: services,
            on: MultiThreadedEventLoopGroup(numberOfThreads: 1)
        )

        XCTAssertNoThrow(try container.make(JWKSSignerRepository.self))
    }
}

extension JWKSSignerRepositoryTests {

    func mockContainer() -> Container {
        var services = Services.default()
        services.register(MockClient(), as: [Client.self])

        var config = Config()
        config.prefer(MockClient.self, for: Client.self)

        return BasicContainer(
            config: config,
            environment: .testing,
            services: services,
            on: MultiThreadedEventLoopGroup(numberOfThreads: 1)
        )
    }

    static var privateJWK: Data {
        return "{\"kty\":\"RSA\",\"d\":\"L4z0tz7QWE0aGuOA32YqCSnrSYKdBTPFDILCdfHonzfP7WMPibz4jWxu_FzNk9s4Dh-uN2lV3NGW10pAsnqffD89LtYanRjaIdHnLW_PFo5fEL2yltK7qMB9hO1JegppKCfoc79W4-dr-4qy1Op0B3npOP-DaUYlNamfDmIbQW32UKeJzdGIn-_ryrBT7hQW6_uHLS2VFPPk0rNkPPKZYoNaqGnJ0eaFFF-dFwiThXIpPz--dxTAL8xYf275rjG8C9lh6awOfJSIdXMVuQITWf62E0mSQPR2-219bShMKriDYcYLbT3BJEgOkRBBHGuHo9R5TN298anxZqV1u5jtUQ\",\"e\":\"AQAB\",\"use\":\"sig\",\"kid\":\"1234\",\"alg\":\"RS256\",\"n\":\"gWu7yhI35FScdKARYboJoAm-T7yJfJ9JTvAok_RKOJYcL8oLIRSeLqQX83PPZiWdKTdXaiGWntpDu6vW7VAb-HWPF6tNYSLKDSmR3sEu2488ibWijZtNTCKOSb_1iAKAI5BJ80LTqyQtqaKzT0XUBtMsde8vX1nKI05UxujfTX3kqUtkZgLv1Yk1ZDpUoLOWUTtCm68zpjtBrPiN8bU2jqCGFyMyyXys31xFRzz4MyJ5tREHkQCzx0g7AvW0ge_sBTPQ2U6NSkcZvQyDbfDv27cMUHij1Sjx16SY9a2naTuOgamjtUzyClPLVpchX-McNyS0tjdxWY_yRL9MYuw4AQ\"}".convertToData()
    }

    static var publicJWKS: Data {
        return "{\"keys\":[{\"kty\":\"RSA\",\"e\":\"AQAB\",\"use\":\"sig\",\"kid\":\"1234\",\"alg\":\"RS256\",\"n\":\"gWu7yhI35FScdKARYboJoAm-T7yJfJ9JTvAok_RKOJYcL8oLIRSeLqQX83PPZiWdKTdXaiGWntpDu6vW7VAb-HWPF6tNYSLKDSmR3sEu2488ibWijZtNTCKOSb_1iAKAI5BJ80LTqyQtqaKzT0XUBtMsde8vX1nKI05UxujfTX3kqUtkZgLv1Yk1ZDpUoLOWUTtCm68zpjtBrPiN8bU2jqCGFyMyyXys31xFRzz4MyJ5tREHkQCzx0g7AvW0ge_sBTPQ2U6NSkcZvQyDbfDv27cMUHij1Sjx16SY9a2naTuOgamjtUzyClPLVpchX-McNyS0tjdxWY_yRL9MYuw4AQ\"}]}".convertToData()
    }
}
