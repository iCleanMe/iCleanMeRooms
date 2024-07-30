// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iCleanMeRooms",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "iCleanMeRooms",
            targets: ["iCleanMeRooms"]
        ),
        .library(
            name: "iCleanMeRoomsAccessibility",
            targets: ["iCleanMeRoomsAccessibility"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/nikolainobadi/NnTestKit", branch: "main"),
        .package(url: "https://github.com/iCleanMe/iCleanMeSharedUI.git", branch: "main")
    ],
    targets: [
        .target(
            name: "iCleanMeRooms",
            dependencies: [
                "iCleanMeSharedUI",
                "iCleanMeRoomsAccessibility"
            ]
        ),
        .target(
            name: "iCleanMeRoomsAccessibility"
        ),
        .testTarget(
            name: "iCleanMeRoomsTests",
            dependencies: [
                "iCleanMeRooms",
                .product(name: "NnTestHelpers", package: "NnTestKit")
            ]
        ),
    ]
)
