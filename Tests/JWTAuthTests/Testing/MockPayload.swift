//
//  MockPayload.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import JWT
import JWTAuth

struct MockPayload: JWTAuthenticatable, JWTPayload, Equatable {

    init(_ id: String = UUID().uuidString, exp: Date = Date(timeIntervalSinceNow: 3600.0)) {
        self.id = id
        self.exp = exp
    }

    let id: String

    let exp: Date

    func verify(using signer: JWTSigner) throws {
        try ExpirationClaim(value: self.exp).verifyNotExpired()
    }

    static func == (lhs: MockPayload, rhs: MockPayload) -> Bool {
        return lhs.id == rhs.id
    }
}
