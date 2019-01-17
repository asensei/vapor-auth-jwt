//
//  SubjectAuthorizable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation
import Vapor

public protocol SubjectAuthorizable: Authorizable {

    associatedtype SubjectType

    func requireAuthorized(subject: SubjectType) throws
}

public extension SubjectAuthorizable {

    public func isAuthorized(subject: SubjectType?) -> Bool {
        guard let subject = subject else {
            return false
        }

        return (try? self.requireAuthorized(subject: subject)) != nil
    }
}

public extension SubjectAuthorizable where Self.SubjectType: Hashable {

    public func requireAuthorized(anyOfSubjects subjects: Set<SubjectType>?) throws {

        guard let subjects = subjects, !subjects.isEmpty else {
            throw Abort(.forbidden)
        }

        var lastError: Swift.Error?

        for subject in subjects {
            do {
                try self.requireAuthorized(subject: subject)

                return
            } catch {
                lastError = error
            }
        }

        if let lastError = lastError {
            throw lastError
        }
    }

    public func isAuthorized(anyOfSubjects subjects: Set<SubjectType>?) -> Bool {
        return (try? self.requireAuthorized(anyOfSubjects: subjects)) != nil
    }
}
