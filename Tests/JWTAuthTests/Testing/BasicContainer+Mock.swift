//
//  BasicContainer+Mock.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Authentication
import Vapor

extension BasicContainer {
    static var mock: BasicContainer {
        var services = Services.default()
        try! services.register(AuthenticationProvider())

        return BasicContainer(
            config: Config(),
            environment: .testing,
            services: services,
            on: MultiThreadedEventLoopGroup(numberOfThreads: 1)
        )
    }
}
