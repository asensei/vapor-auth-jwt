// swift-tools-version:5.2

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
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
      .library(name: "JWTAuth", targets: ["JWTAuth"])
    ],
    dependencies: [
      .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.5.0")),
      .package(url: "https://github.com/vapor/jwt.git", .upToNextMajor(from: "4.0.0-rc.2"))
    ],
    targets: [
        .target(name: "JWTAuth", dependencies: [.product(name: "Vapor", package: "vapor"), .product(name: "JWT", package: "jwt")]),
        .testTarget(name: "JWTAuthTests", dependencies: [.product(name: "XCTVapor", package: "vapor"), "JWTAuth"])
    ]
)
