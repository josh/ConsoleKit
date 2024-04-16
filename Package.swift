// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ConsoleKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "ConsoleKit",
            targets: ["ConsoleKit"]
        ),
    ],
    targets: [
        .target(
            name: "ConsoleKit"),
        .testTarget(
            name: "ConsoleKitTests",
            dependencies: ["ConsoleKit"]
        ),
    ]
)
