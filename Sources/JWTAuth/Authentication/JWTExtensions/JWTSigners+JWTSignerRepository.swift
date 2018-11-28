//
//  JWTSigners+JWTSignerRepository.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 26/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import JWT
import Service

extension JWTSigners: JWTSignerRepository {

    public func get(kid: String, on worker: Container) throws -> Future<JWTSigner> {
        return try worker.future(self.requireSigner(kid: kid))
    }
}

extension JWTSigners: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {
        return .init()
    }
}
