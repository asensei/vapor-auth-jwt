//
//  Request+Authorizable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Authentication
import Vapor

// MARK: - Subject

public extension Request {

    public func requireAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, subject: A.SubjectType) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(subject)
    }

    public func requireAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, anyOf subjects: Set<A.SubjectType>) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(anyOf: subjects)
    }

    public func isAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, subject: A.SubjectType) -> Bool {
        return (try? self.requireAuthorized(A.self, subject: subject)) != nil
    }

    public func isAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, anyOf subjects: Set<A.SubjectType>) -> Bool {
        return (try? self.requireAuthorized(A.self, anyOf: subjects)) != nil
    }
}

// MARK: - Permission

public extension Request {

    public func requireAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, permission: A.PermissionType) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(permission)
    }

    public func requireAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, allOf permissions: Set<A.PermissionType>) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(allOf: permissions)
    }

    public func requireAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, anyOf permissions: Set<A.PermissionType>) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(anyOf: permissions)
    }

    public func isAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, permission: A.PermissionType) -> Bool {
        return (try? self.requireAuthorized(A.self, permission: permission)) != nil
    }

    public func isAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, allOf permissions: Set<A.PermissionType>) -> Bool {
        return (try? self.requireAuthorized(A.self, allOf: permissions)) != nil
    }

    public func isAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, anyOf permissions: Set<A.PermissionType>) -> Bool {
        return (try? self.requireAuthorized(A.self, anyOf: permissions)) != nil
    }
}
