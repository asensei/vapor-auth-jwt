//
//  JWTAuthProvider.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 26/04/2017.
//  Copyright © 2017 Asensei Inc. All rights reserved.
//

import Foundation
import Authentication
import Service

public final class JWTAuthProvider: Provider {

    public init() {

    }

    public func register(_ services: inout Services) throws {
        try services.register(Authentication.AuthenticationProvider())
        services.register(JWKSSignerRepository.Config.self)
        services.register(JWKSSignerRepository.self)
    }

    public func didBoot(_ worker: Container) throws -> EventLoopFuture<Void> {
        return .done(on: worker)
    }
}
