// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to
// build this package and is used by Flutter's Swift Package Manager support.
import PackageDescription

let package = Package(
    name: "flutter_tapresearch",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-tapresearch", targets: ["flutter_tapresearch"])
    ],
    dependencies: [
        // TapResearch iOS SDK 3.x via Swift Package Manager.
        // NOTE: the SDK's repo currently tags only a beta for SPM; bump this to
        // the latest stable tag when one is published.
        .package(
            url: "https://github.com/TapResearch/TapResearch-iOS-SDK",
            exact: "3.8.0--beta03"
        )
    ],
    targets: [
        .target(
            name: "flutter_tapresearch",
            dependencies: [
                .product(name: "TapResearchSDK", package: "TapResearch-iOS-SDK")
            ]
        )
    ]
)
