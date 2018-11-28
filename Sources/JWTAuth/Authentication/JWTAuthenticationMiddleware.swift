//
//  JWTAuthenticationMiddleware.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 23/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import JWT
import Vapor

public final class JWTAuthenticationMiddleware<A: JWTAuthenticatable> {

    // MARK: Initialization

    public required init(_ type: A.Type = A.self, signers: JWTSignerRepository) {
        self.signers = signers
    }

    // MARK: Accessing Attributes

    public let signers: JWTSignerRepository
}

// MARK: - Middleware

extension JWTAuthenticationMiddleware: Middleware {

    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {

        // Process the request if the user has already been authenticated by a previous middleware
        guard try !request.isAuthenticated(A.self) else {
            return try next.respond(to: request)
        }

        // Process the request if there isn't a token
        guard let rawToken = request.http.headers.bearerAuthorization?.token else {
            return try next.respond(to: request)
        }

        return A.authenticate(using: rawToken, signers: self.signers, on: request).flatMap { jwt in
            if let jwt = jwt {
                // Set authenticated on request
                try request.authenticate(jwt)
            }

            return try next.respond(to: request)
        }
    }
}

// MARK: - ServiceType

extension JWTAuthenticationMiddleware: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {
        return try .init(signers: worker.make())
    }
}
