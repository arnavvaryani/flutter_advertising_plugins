// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutter_mintegral",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-mintegral", targets: ["flutter_mintegral"])
    ],
    dependencies: [
        // Mintegral iOS SDK 8.x via Swift Package Manager (binary xcframework).
        .package(
            url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package.git",
            exact: "8.1.5"
        )
    ],
    targets: [
        .target(
            name: "flutter_mintegral",
            dependencies: [
                .product(name: "MintegralAdSDK", package: "MintegralAdSDK-Swift-Package")
            ],
            // The Mintegral SDK requires the -ObjC linker flag in the host app.
            linkerSettings: [
                .unsafeFlags(["-ObjC"])
            ]
        )
    ]
)
