// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcresultReporter",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "xcresult-reporter", targets: ["XcresultReporter"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.5.0"),
        .package(url: "https://github.com/davidahouse/XCResultKit.git", exact: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "XcresultReporter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XCResultKit", package: "XCResultKit")
            ]
        )
    ]
)
