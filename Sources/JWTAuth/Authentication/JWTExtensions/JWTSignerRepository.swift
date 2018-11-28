//
//  JWTSignerRepository.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 26/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import JWT
import Service

public protocol JWTSignerRepository: ServiceType {

    func get(kid: String, on worker: Container) throws -> Future<JWTSigner>
}
