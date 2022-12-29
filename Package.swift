// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "AllAppleDevices",
    products: [
        .executable(
            name: "all-apple-devices",
            targets: ["ExecutableCommandLineInterface"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", exact: "4.2.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", exact: "2.3.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift", exact: "0.14.1"),
        .package(url: "https://github.com/apple/swift-algorithms", exact: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.2.0"),
    ],
    targets: [
        .target(
            name: "CommandLineInterface",
            dependencies: [
                .product(name: "Files", package: "Files"),
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "CommandLineInterfaceTests",
            dependencies: [
                .target(name: "CommandLineInterface"),
            ]
        ),
        .executableTarget(
            name: "ExecutableCommandLineInterface",
            dependencies: [
                .target(name: "CommandLineInterface"),
            ]
        ),
    ]
)
