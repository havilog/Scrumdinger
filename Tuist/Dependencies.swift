import ProjectDescription

let packages: [Package] = [
//    .lottie,
]
let dependencies: Dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        packages,
        baseSettings: Settings.settings(
            base: [:],
            defaultSettings: .recommended
        )
    ),
    platforms: [.iOS]
)

public extension Package {
    static let lottie: Package = .package(url: "https://github.com/airbnb/lottie-ios", .exact("3.4.3"))
}
