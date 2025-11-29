// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "miet_practice_common",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "MPCore",
            targets: ["MPCore"]
        ),
        .library(
            name: "MPDTO",
            targets: ["MPDTO"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0")
    ],
    targets: [
        .target(
            name: "MPCore"
        ),
        .target(
            name: "MPDTO",
            dependencies: [
                "MPCore",
                .product(name: "Vapor", package: "vapor")
            ]
        )
    ]
)
