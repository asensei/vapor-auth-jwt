//
//  BasicContainer+Mock.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Vapor

extension BasicContainer {
    static var mock: BasicContainer {
        let services = Services.default()

        return BasicContainer(
            config: Config(),
            environment: .testing,
            services: services,
            on: EmbeddedEventLoop()
        )
    }
}
