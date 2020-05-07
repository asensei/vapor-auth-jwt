//
//  Request+Authorizable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Vapor

// MARK: - Subject

extension Request.Authentication {

    public func require<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, subject: A.SubjectType?) throws {
        let authorizable: A = try self.require()
        try authorizable.require(subject: subject)
    }

    public func require<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, anyOfSubjects subjects: Set<A.SubjectType>?) throws {
        let authorizable: A = try self.require()
        try authorizable.require(anyOfSubjects: subjects)
    }

    public func has<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, subject: A.SubjectType?) -> Bool {
        return (try? self.require(A.self, subject: subject)) != nil
    }

    public func has<A: Authenticatable & SubjectAuthorizable>(_ type: A.Type = A.self, anyOfSubjects subjects: Set<A.SubjectType>?) -> Bool {
        return (try? self.require(A.self, anyOfSubjects: subjects)) != nil
    }
}

// MARK: - Permission

extension Request.Authentication {

    public func require<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, permission: A.PermissionType) throws {
        let authorizable: A = try self.require()
        try authorizable.require(permission: permission)
    }

    public func require<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, allOfPermissions permissions: Set<A.PermissionType>) throws {
        let authorizable: A = try self.require()
        try authorizable.require(allOfPermissions: permissions)
    }

    public func require<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, anyOfPermissions permissions: Set<A.PermissionType>) throws {
        let authorizable: A = try self.require()
        try authorizable.require(anyOfPermissions: permissions)
    }

    public func has<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, permission: A.PermissionType) -> Bool {
        return (try? self.require(A.self, permission: permission)) != nil
    }

    public func has<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, allOfPermissions permissions: Set<A.PermissionType>) -> Bool {
        return (try? self.require(A.self, allOfPermissions: permissions)) != nil
    }

    public func has<A: Authenticatable & PermissionAuthorizable>(_ type: A.Type = A.self, anyOfPermissions permissions: Set<A.PermissionType>) -> Bool {
        return (try? self.require(A.self, anyOfPermissions: permissions)) != nil
    }
}
