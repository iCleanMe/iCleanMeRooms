// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iCleanMeRooms",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "iCleanMeRooms",
            targets: ["iCleanMeRooms"]
        ),
        .library(
            name: "iCleanMeRoomsCore",
            targets: ["iCleanMeRoomsCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/nikolainobadi/NnTestKit", branch: "main"),
        .package(url: "https://github.com/iCleanMe/iCleanMeSharedUI.git", branch: "main")
    ],
    targets: [
        .target(name: "iCleanMeRoomsCore"),
        .target(
            name: "iCleanMeRooms",
            dependencies: [
                "RoomUI"
            ]
        ),
        .target(
            name: "RoomUI",
            dependencies: [
                "iCleanMeSharedUI",
                "RoomPresentation"
            ],
            path: "Sources/Internal/RoomUI"
        ),
        .target(
            name: "RoomPresentation",
            dependencies: [
                "iCleanMeRoomsCore"
            ],
            path: "Sources/Internal/RoomPresentation"
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
