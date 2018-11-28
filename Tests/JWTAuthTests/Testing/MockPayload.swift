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

    init(_ id: String = UUID().uuidString) {
        self.id = id
    }

    let id: String

    func verify(using signer: JWTSigner) throws { }

    static func == (lhs: MockPayload, rhs: MockPayload) -> Bool {
        return lhs.id == rhs.id
    }
}
