// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS("16")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Market",
            targets: ["Market"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Market",
            dependencies: ["DomainModels", "UIComponents", "SAL", "Product"]),
        .target(
            name: "Product",
            dependencies: ["DomainModels", "UIComponents", "SAL"]),
        .target(
            name: "SAL",
            dependencies: ["DTOToDomain", "DomainModels"]),
        .target(
            name: "DTOToDomain",
            dependencies: ["DomainModels"]),
        .target(
            name: "DomainModels",
            dependencies: []),
        .target(
            name: "UIComponents",
            dependencies: []),
    ]
)
