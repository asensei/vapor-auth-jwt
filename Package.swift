// swift-tools-version:5.1

//
//  Package.swift
//  JWTAuth
//
//  Created by Valerio Mazzeo on 27/11/2018.
//  Copyright © 2018 Asensei Inc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "JWTAuth",
    products: [
      .library(name: "JWTAuth", targets: ["JWTAuth"])
    ],
    dependencies: [
      .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "3.3.1")),
      .package(url: "https://github.com/vapor/auth.git", .upToNextMajor(from: "2.0.4")),
      .package(url: "https://github.com/vapor/jwt.git", .upToNextMajor(from: "3.0.0"))
    ],
    targets: [
        .target(name: "JWTAuth", dependencies: ["Vapor", "Authentication", "JWT"]),
        .testTarget(name: "JWTAuthTests", dependencies: ["JWTAuth"])
    ]
)
