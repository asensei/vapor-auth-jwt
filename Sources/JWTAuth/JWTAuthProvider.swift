//
//  JWTAuthProvider.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Authentication
import Service

public final class JWTAuthProvider: Provider {

    public init() { }

    public func register(_ services: inout Services) throws {
        try services.register(Authentication.AuthenticationProvider())
        services.register(JWKSSignerRepository.Config.self)
        services.register(JWKSSignerRepository.self)
    }

    public func didBoot(_ worker: Container) throws -> EventLoopFuture<Void> {
        return .done(on: worker)
    }
}
