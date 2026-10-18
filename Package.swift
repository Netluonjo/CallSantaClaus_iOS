// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CallSantaClaus",
    defaultLocalization: "vi",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CallSantaClaus",
            targets: ["CallSantaClaus"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CallSantaClaus",
            dependencies: [],
            path: "CallSantaClaus",
            resources: [
                .process("Assets.xcassets"),
                .process("Resources")
            ]
        )
    ]
)
