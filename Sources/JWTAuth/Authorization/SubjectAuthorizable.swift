//
//  SubjectAuthorizable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation

public protocol SubjectAuthorizable: Authorizable {

    associatedtype SubjectType: Equatable

    func requireAuthorized(_ subject: SubjectType) throws
}

public extension SubjectAuthorizable {

    public func isAuthorized(_ subject: SubjectType) -> Bool {
        return (try? self.requireAuthorized(subject)) != nil
    }
}

public extension SubjectAuthorizable where Self.SubjectType: Hashable {

    public func requireAuthorized(anyOf subjects: Set<SubjectType>) throws {

        var lastError: Swift.Error?

        for subject in subjects {
            do {
                try self.requireAuthorized(subject)
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
