// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftLox",
  platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17)],
  products: [
    .library(name: "SwiftLox", targets: ["SwiftLox"]),
    .executable(name: "SwiftLoxCLI", targets: ["SwiftLoxCLI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0")
    // .package(url: "https://github.com/swiftlang/swift-testing.git", from: "6.0.0"),
  ],
  targets: [
    .target(name: "SwiftLox"),
    .executableTarget(
      name: "SwiftLoxCLI",
      dependencies: [
        .target(name: "SwiftLox"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .testTarget(
      name: "SwiftLoxTests",
      dependencies: [
        // .product(name: "Testing", package: "swift-testing"),
        .byName(name: "SwiftLox"),
        .byName(name: "SwiftLoxCLI"),
      ]
    ),
  ]
)
