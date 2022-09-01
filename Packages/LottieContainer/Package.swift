// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LottieContainer",
  platforms: [
    .iOS(.v14),
    .macOS(.v11)
  ],
  products: [
    .library(
      name: "LottieContainer",
      targets: ["LottieContainer"]
    )
  ],
  dependencies: [
    .package(
      name: "Lottie",
      url: "https://github.com/airbnb/lottie-ios",
      from: "3.2.0"
    ),
  ],
  targets: [
    .target(
      name: "LottieContainer",
      dependencies: [
        .product(
          name: "Lottie",
          package: "Lottie"
        )
      ],
      path: "Sources",
      resources: [
        .process("Lottie/success_star_light.json"),
        .process("Lottie/success_star_dark.json"),
        .process("Lottie/empty_light.json"),
        .process("Lottie/empty_dark.json")
      ]
    ),
    .testTarget(
      name: "LottieContainerTests",
      dependencies: [
        .target(name: "LottieContainer")
      ],
      path: "Tests"
    )
  ],
  swiftLanguageVersions: [.v5]
)
