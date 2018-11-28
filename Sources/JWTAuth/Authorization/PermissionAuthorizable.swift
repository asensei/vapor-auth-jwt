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

    func requireAuthorized(permission: PermissionType) throws
}

public extension PermissionAuthorizable {

    public func requireAuthorized(allOfPermissions permissions: Set<PermissionType>) throws {
        for permission in permissions {
            try self.requireAuthorized(permission: permission)
        }
    }

    public func requireAuthorized(anyOfPermissions permissions: Set<PermissionType>) throws {

        var lastError: Swift.Error?

        for permission in permissions {
            do {
                try self.requireAuthorized(permission: permission)

                return
            } catch {
                lastError = error
            }
        }

        if let lastError = lastError {
            throw lastError
        }
    }

    public func isAuthorized(permission: PermissionType) -> Bool {
        return (try? self.requireAuthorized(permission: permission)) != nil
    }

    public func isAuthorized(allOfPermissions permissions: Set<PermissionType>) -> Bool {
        return (try? self.requireAuthorized(allOfPermissions: permissions)) != nil
    }

    public func isAuthorized(anyOfPermissions permissions: Set<PermissionType>) -> Bool {
        return (try? self.requireAuthorized(anyOfPermissions: permissions)) != nil
    }
}
