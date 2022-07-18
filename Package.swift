// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "PerspectiveTransform",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "PerspectiveTransform",
            targets: ["PerspectiveTransform"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PerspectiveTransform",
            dependencies: [],
            path: "Pod/Classes")
    ]
)
