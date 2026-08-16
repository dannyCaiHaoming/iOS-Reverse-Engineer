// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BusinessLogicLab",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "BusinessLogicCore", targets: ["BusinessLogicCore"]),
        .executable(name: "BusinessLogicLabCLI", targets: ["BusinessLogicLabCLI"]),
        .executable(name: "BusinessLogicLabChecks", targets: ["BusinessLogicLabChecks"])
    ],
    targets: [
        .target(name: "BusinessLogicCore"),
        .executableTarget(
            name: "BusinessLogicLabCLI",
            dependencies: ["BusinessLogicCore"]
        ),
        .executableTarget(
            name: "BusinessLogicLabChecks",
            dependencies: ["BusinessLogicCore"]
        )
    ]
)
