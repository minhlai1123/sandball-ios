// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SandAdventure",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SandAdventure",
            targets: ["SandAdventure"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SandAdventure",
            dependencies: [],
            path: "SandAdventure",
            exclude: ["Tests", "Resources/Info.plist"],
            resources: [
                .process("Resources/Levels"),
                .process("Resources/Audio")
            ]
        ),
        .testTarget(
            name: "SandAdventureTests",
            dependencies: ["SandAdventure"],
            path: "SandAdventure/Tests"
        ),
    ]
)
