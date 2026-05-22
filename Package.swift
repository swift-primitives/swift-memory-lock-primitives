// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-memory-lock-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Memory Lock Primitives",
            targets: ["Memory Lock Primitives"]
        ),
        .library(
            name: "Memory Lock Primitives Test Support",
            targets: ["Memory Lock Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-memory-primitives"),
        .package(path: "../swift-error-primitives"),
    ],
    targets: [
        .target(
            name: "Memory Lock Primitives",
            dependencies: [
                .product(name: "Memory Primitive", package: "swift-memory-primitives"),
                .product(name: "Error Primitives", package: "swift-error-primitives"),
            ]
        ),
        .target(
            name: "Memory Lock Primitives Test Support",
            dependencies: [
                "Memory Lock Primitives",
                .product(name: "Memory Primitives Test Support", package: "swift-memory-primitives"),
            ],
            path: "Tests/Support"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("RawLayout"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
