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

    func requireAuthorized(_ permission: PermissionType) throws
}

public extension PermissionAuthorizable {

    public func isAuthorized(_ permission: PermissionType) -> Bool {
        return (try? self.requireAuthorized(permission)) != nil
    }

    public func requireAuthorized(allOf permissions: Set<PermissionType>) throws {
        for permission in permissions {
            try self.requireAuthorized(permission)
        }
    }

    public func isAuthorized(allOf permissions: Set<PermissionType>) -> Bool {
        return (try? self.requireAuthorized(allOf: permissions)) != nil
    }

    public func requireAuthorized(anyOf permissions: Set<PermissionType>) throws {

        var lastError: Swift.Error?

        for permission in permissions {
            do {
                try self.requireAuthorized(permission)
                break
            } catch {
                lastError = error
            }
        }

        if let lastError = lastError {
            throw lastError
        }
    }
}
