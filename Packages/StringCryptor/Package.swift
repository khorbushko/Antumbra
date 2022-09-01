// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "StringCryptor",
  platforms: [
    .iOS(.v14),
    .macOS(.v10_15)
  ],
  products: [
    .library(
      name: "StringCryptor",
      targets: ["StringCryptor"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "StringCryptor",
      dependencies: []),
    .testTarget(
      name: "StringCryptorTests",
      dependencies: ["StringCryptor"]),
  ]
)
