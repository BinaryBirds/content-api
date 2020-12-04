// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "content-api",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "ContentApi", targets: ["ContentApi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.35.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "ContentApi", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
        ]),
        .testTarget(name: "ContentApiTests", dependencies: ["ContentApi"]),
    ]
)
