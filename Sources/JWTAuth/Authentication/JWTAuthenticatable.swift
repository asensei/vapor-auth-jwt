//
//  JWTAuthenticatable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 20/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Authentication
import JWT

/// Authenticatable by `JWT token` auth.
public protocol JWTAuthenticatable: Authenticatable {

    /// Authenticates using the supplied jwt and signer.
    static func authenticate(using data: LosslessDataConvertible, signers: JWTSignerRepository, on worker: Container) -> Future<Self?>
}

public extension JWTAuthenticatable where Self: JWTPayload {

    public static func authenticate(using data: LosslessDataConvertible, signers: JWTSignerRepository, on worker: Container) -> Future<Self?> {
        do {
            return try JWT<Self>.data(data, verifiedUsing: signers, on: worker).map { $0.payload }
        } catch {
            return worker.future(error: error)
        }
    }
}
