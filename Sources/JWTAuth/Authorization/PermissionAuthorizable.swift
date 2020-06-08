//
//  PermissionAuthorizable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Vapor

public protocol PermissionAuthorizable: Authorizable {

    associatedtype PermissionType: Hashable

    func require(permission: PermissionType) throws
}

extension PermissionAuthorizable {

    public func require(allOfPermissions permissions: Set<PermissionType>) throws {
        for permission in permissions {
            try self.require(permission: permission)
        }
    }

    public func require(anyOfPermissions permissions: Set<PermissionType>) throws {

        var lastError: Swift.Error?

        for permission in permissions {
            do {
                try self.require(permission: permission)

                return
            } catch {
                lastError = error
            }
        }

        if let lastError = lastError {
            throw lastError
        }
    }

    public func has(permission: PermissionType) -> Bool {
        return (try? self.require(permission: permission)) != nil
    }

    public func has(allOfPermissions permissions: Set<PermissionType>) -> Bool {
        return (try? self.require(allOfPermissions: permissions)) != nil
    }

    public func has(anyOfPermissions permissions: Set<PermissionType>) -> Bool {
        return (try? self.require(anyOfPermissions: permissions)) != nil
    }
}
