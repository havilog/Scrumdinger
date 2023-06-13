// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios", exact: "3.4.3"),
    ]
)