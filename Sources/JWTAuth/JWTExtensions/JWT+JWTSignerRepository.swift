//
//  JWT+JWTSignerRepository.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 26/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import JWT
import Vapor

extension JWT {

    public static func data(_ data: LosslessDataConvertible, verifiedUsing signers: JWTSignerRepository, on worker: Container) throws -> Future<JWT<Payload>> {
        let parts = data.convertToData().split(separator: .period)
        guard parts.count == 3 else {
            throw JWTError(identifier: "invalidJWT", reason: "Malformed JWT")
        }

        let headerData = Data(parts[0])
        let payloadData = Data(parts[1])
        let signatureData = Data(parts[2])

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970

        guard let decodedHeader = Data(base64URLEncoded: headerData) else {
            throw JWTError(identifier: "base64", reason: "JWT header is not valid base64-url")
        }

        let header = try jsonDecoder.decode(JWTHeader.self, from: decodedHeader)
        guard let kid = header.kid else {
            throw JWTError(identifier: "missingKID", reason: "`kid` header property required to identify signer")
        }

        return try signers.get(kid: kid, on: worker).map { signer in
            guard try signer.verify(signatureData, header: headerData, payload: payloadData) else {
                throw JWTError(identifier: "invalidSignature", reason: "Invalid JWT signature")
            }

            guard let decodedPayload = Data(base64URLEncoded: payloadData) else {
                throw JWTError(identifier: "base64", reason: "JWT payload is not valid base64-url")
            }

            let header = header
            let payload = try jsonDecoder.decode(Payload.self, from: decodedPayload)
            try payload.verify(using: signer)

            return JWT<Payload>(header: header, payload: payload)
        }
    }
}
