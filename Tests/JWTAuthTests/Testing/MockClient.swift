//
//  MockClient.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Vapor

class MockClient: Client, ServiceType {

    required init() { }

    var send: ((Request) -> Future<Response>)?

    var container: Container = BasicContainer.mock

    func send(_ req: Request) -> Future<Response> {
        return self.send?(req) ?? self.container.future(error: URLError(.badURL))
    }

    static func makeService(for worker: Container) throws -> Self {
        return self.init()
    }
}
