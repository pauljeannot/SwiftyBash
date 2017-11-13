// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyBash",
    products: [
        .library(name: "SwiftyBash", targets: ["SwiftyBash"])
    ],
    targets: [
        .target(
            name: "SwiftyBash",
            path: "Sources"
        ),
        .testTarget(
            name:"SwiftyBashTests",
            dependencies:["SwiftyBash"]
        ),
    ]
)
