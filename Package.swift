// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "leaf",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Leaf", targets: ["Leaf"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gzqyl/leaf-kit.git", branch: "main"),        
        .package(url: "https://github.com/gzqyl/vapor.git", branch: "main"),
        .package(url: "https://github.com/gzqyl/swift-algorithms.git", branch: "main"),
    ],
    targets: [
        .target(name: "Leaf", dependencies: [
            .product(name: "LeafKit", package: "leaf-kit"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Algorithms", package: "swift-algorithms")
        ]),
        .testTarget(name: "LeafTests", dependencies: [
            .target(name: "Leaf"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
    ]
)
