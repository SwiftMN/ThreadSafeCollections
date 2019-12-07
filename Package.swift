// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThreadSafeCollections",
    platforms: [
      .iOS(.v12)
    ],
    products: [
        .library(
            name: "ThreadSafeCollections",
            targets: ["ThreadSafeCollections"]),
    ],
    targets: [
        .target(
            name: "ThreadSafeCollections",
            dependencies: []),
        .testTarget(
            name: "ThreadSafeCollectionsTests",
            dependencies: ["ThreadSafeCollections"]),
    ]
)
