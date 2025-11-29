// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MPUtils",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(name: "MPCore", targets: ["MPCore"]),
        .library(name: "MPDTO", targets: ["MPDTO"]),
        .executable(name: "MPResultParser", targets: ["MPResultParser"]),
        .executable(name: "MPResultReporter", targets: ["MPResultReporter"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.5.0"),
        .package(url: "https://github.com/davidahouse/XCResultKit.git", exact: "1.2.0")
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
        ),
        .executableTarget(
            name: "MPResultParser",
            dependencies: [
                "MPCore",
                "MPDTO",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XCResultKit", package: "XCResultKit")
            ]
        ),
        .executableTarget(
            name: "MPResultReporter",
            dependencies: [
                "MPCore",
                "MPDTO",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XCResultKit", package: "XCResultKit")
            ]
        )
    ]
)
