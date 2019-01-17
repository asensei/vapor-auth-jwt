//
//  MockAuthorizable.swift
//  JWTAuthTests
//
//  Created by Valerio Mazzeo on 28/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Authentication
import JWTAuth

struct MockAuthorizable {
    var subject: String
    var permissions: Set<String>

    init(subject: String, permissions: Set<String> = []) {
        self.subject = subject
        self.permissions = permissions
    }
}

extension MockAuthorizable: SubjectAuthorizable {

    func requireAuthorized(subject: String?) throws {
        guard self.subject == subject else {
            throw MockAuthorizableError.invalidSubject
        }
    }
}

extension MockAuthorizable: PermissionAuthorizable {

    func requireAuthorized(permission: String) throws {
        guard self.permissions.contains(permission) else {
            throw MockAuthorizableError.invalidPermission
        }
    }
}

extension MockAuthorizable: Authenticatable { }

enum MockAuthorizableError: Swift.Error {
    case invalidSubject
    case invalidPermission
}
