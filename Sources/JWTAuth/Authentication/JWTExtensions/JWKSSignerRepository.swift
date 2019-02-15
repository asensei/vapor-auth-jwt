//
//  JWKSSignerRepository.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 26/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import JWT
import HTTP
import Vapor

public final class JWKSSignerRepository {

    public required init(jwksURL: URLRepresentable, cacheMinTTL: TimeInterval = 60.0) {
        self.jwksURL = jwksURL
        self.cacheMinTTL = cacheMinTTL
    }

    public convenience init(config: Config) {
        self.init(jwksURL: config.jwksURL, cacheMinTTL: config.cacheMinTTL)
    }

    public let jwksURL: URLRepresentable

    public let cacheMinTTL: TimeInterval

    private var cache: (signers: JWTSigners, createdAt: Date)?
}

extension JWKSSignerRepository: JWTSignerRepository {

    public func get(kid: String, on container: Container) throws -> Future<JWTSigner> {

        if let signer = self.cache?.signers.signer(kid: kid) {
            return container.future(signer)
        }

        // Prevents cache to be updated more often than `cacheMinTTL`
        guard abs((self.cache?.createdAt ?? Date.distantFuture).timeIntervalSinceNow) > self.cacheMinTTL else {
            throw JWTError(identifier: "unknownKID", reason: "No signers are available for the supplied `kid`")
        }

        return try container.make(Client.self).get(self.jwksURL).flatMap { response in
            return try response.content.decode(json: JWKS.self, using: JSONDecoder()).map { jwks in
                let signers = try JWTSigners(jwks: jwks)
                self.cache = (signers: signers, createdAt: Date())

                return try signers.requireSigner(kid: kid)
            }
        }
    }
}

extension JWKSSignerRepository: ServiceType {

    public static func makeService(for worker: Container) throws -> Self {
        return try .init(config: worker.make())
    }
}

public extension JWKSSignerRepository {

    public struct Config: ServiceType {

        public init(jwksURL: URLRepresentable, cacheMinTTL: TimeInterval) {
            self.jwksURL = jwksURL
            self.cacheMinTTL = cacheMinTTL
        }

        public init(environment: [String: String] = ProcessInfo.processInfo.environment) throws {

            guard let jwksURL = environment[EnvironmentKey.jwksURL.rawValue] else {
                throw Error.missingEnvironmentKey(.jwksURL)
            }

            var cacheMinTTL: TimeInterval = 60.0
            if let rawCacheMinTTL = environment[EnvironmentKey.cacheMinTTL.rawValue] {
                guard let intervalCacheMinTTL = TimeInterval(rawCacheMinTTL) else {
                    throw Error.invalidCacheMinTTL
                }

                cacheMinTTL = intervalCacheMinTTL
            }

            self.init(jwksURL: jwksURL, cacheMinTTL: cacheMinTTL)
        }

        public let jwksURL: URLRepresentable

        public let cacheMinTTL: TimeInterval

        public static func makeService(for worker: Container) throws -> Config {
            return try .init()
        }
    }
}

public extension JWKSSignerRepository.Config {

    public enum EnvironmentKey: String {
        case jwksURL = "JWTAUTH_JWKS_URL"
        case cacheMinTTL = "JWTAUTH_JWKS_CACHE_MIN_TTL"
    }

    public enum Error: Swift.Error {
        case missingEnvironmentKey(EnvironmentKey)
        case invalidCacheMinTTL
    }
}
