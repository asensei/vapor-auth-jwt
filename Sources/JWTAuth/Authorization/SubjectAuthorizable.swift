//
//  SubjectAuthorizable.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import Foundation

public protocol SubjectAuthorizable: Authorizable {

    associatedtype SubjectType

    func require(subject: SubjectType?) throws
}

extension SubjectAuthorizable {

    public func has(subject: SubjectType?) -> Bool {
        return (try? self.require(subject: subject)) != nil
    }
}

extension SubjectAuthorizable where Self.SubjectType: Hashable {

    public func require(anyOfSubjects subjects: Set<SubjectType>?) throws {

        guard let subjects = subjects, !subjects.isEmpty else {
            try self.require(subject: nil)

            return
        }

        var lastError: Swift.Error?

        for subject in subjects {
            do {
                try self.require(subject: subject)

                return
            } catch {
                lastError = error
            }
        }

        if let lastError = lastError {
            throw lastError
        }
    }

    public func has(anyOfSubjects subjects: Set<SubjectType>?) -> Bool {
        return (try? self.require(anyOfSubjects: subjects)) != nil
    }
}
