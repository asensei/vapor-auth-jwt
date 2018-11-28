//
//  LinuxMain.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

#if os(Linux)

import XCTest
@testable import JWTAuthTests

XCTMain([
    testCase(JWTAuthProviderTests.allTests),
    testCase(JWTAuthenticatableTests.allTests),
    testCase(JWTSignersJWTSignerRepositoryTests.allTests),
    testCase(JWTJWTSignerRepositoryTests.allTests),
    testCase(JWKSSignerRepositoryTests.allTests),
    testCase(JWTAuthenticationMiddlewareTests.allTests),
    testCase(SubjectAuthorizableTests.allTests),
    testCase(PermissionAuthorizableTests.allTests),
    testCase(RequestAuthorizableTests.allTests)
])

#endif
