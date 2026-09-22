// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ragnarok-data-converter",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0"),
        .package(url: "https://github.com/arkadeleon/ragnarok-lua.git", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "ragnarok-data-converter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "RagnarokLua", package: "ragnarok-lua"),
            ],
            resources: [
                .copy("Lua/dkjson.lua"),
            ]
        ),
    ]
)
