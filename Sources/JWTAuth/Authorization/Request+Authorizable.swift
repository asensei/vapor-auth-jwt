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

extension Request {

    public func requireAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, subject: A.SubjectType?) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(subject: subject)
    }

    public func requireAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, anyOfSubjects subjects: Set<A.SubjectType>?) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(anyOfSubjects: subjects)
    }

    public func isAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, subject: A.SubjectType?) -> Bool {
        return (try? self.requireAuthorized(A.self, subject: subject)) != nil
    }

    public func isAuthorized<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, anyOfSubjects subjects: Set<A.SubjectType>?) -> Bool {
        return (try? self.requireAuthorized(A.self, anyOfSubjects: subjects)) != nil
    }
}

// MARK: - Permission

extension Request {

    public func requireAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, permission: A.PermissionType) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(permission: permission)
    }

    public func requireAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, allOfPermissions permissions: Set<A.PermissionType>) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(allOfPermissions: permissions)
    }

    public func requireAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, anyOfPermissions permissions: Set<A.PermissionType>) throws {
        let authorizable: A = try self.requireAuthenticated()
        try authorizable.requireAuthorized(anyOfPermissions: permissions)
    }

    public func isAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, permission: A.PermissionType) -> Bool {
        return (try? self.requireAuthorized(A.self, permission: permission)) != nil
    }

    public func isAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, allOfPermissions permissions: Set<A.PermissionType>) -> Bool {
        return (try? self.requireAuthorized(A.self, allOfPermissions: permissions)) != nil
    }

    public func isAuthorized<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, anyOfPermissions permissions: Set<A.PermissionType>) -> Bool {
        return (try? self.requireAuthorized(A.self, anyOfPermissions: permissions)) != nil
    }
}
