// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Breeze",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "BreezeApp", targets: ["BreezeApp"])
    ],
    targets: [
        .target(name: "BreezeDomain"),
        .target(name: "BreezePorts", dependencies: ["BreezeDomain"]),
        .target(name: "BreezeApplication", dependencies: ["BreezeDomain", "BreezePorts"]),
        .target(name: "BreezeAdapters", dependencies: ["BreezeDomain", "BreezePorts"]),
        .target(name: "BreezeUI", dependencies: ["BreezeDomain", "BreezePorts"]),
        .executableTarget(
            name: "BreezeApp",
            dependencies: ["BreezeApplication", "BreezeAdapters", "BreezeUI"]
        )
    ]
)
