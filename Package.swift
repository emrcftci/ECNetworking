// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ECNetworking",
    platforms: [
      .iOS(.v12),
    ],
    products: [
        .library(
            name: "ECNetworking",
            targets: ["ECNetworking"]),
    ],
    dependencies: [
      .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.1.0")),
      .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
      .package(url: "https://github.com/Alamofire/AlamofireImage.git", .upToNextMajor(from: "4.2.0")),
      .package(url: "https://github.com/mxcl/PromiseKit.git", .upToNextMajor(from: "6.13.3")),
      .package(url: "https://github.com/sunshinejr/SwiftyUserDefaults.git", .upToNextMajor(from: "4.0.0")),
    ],
    targets: [
        .target(
            name: "ECNetworking",
            dependencies: [
              "ObjectMapper",
              "Alamofire",
              "AlamofireImage",
              "PromiseKit",
              "SwiftyUserDefaults",
            ]),
        .testTarget(
            name: "ECNetworkingTests",
            dependencies: ["ECNetworking"]),
    ]
)
