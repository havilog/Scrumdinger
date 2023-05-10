import ProjectDescription

private let projectName = "Scrumdinger"
private let appName = "Scrumdinger"
private let organizationName = "com.havi"

private let settings = Settings.settings(
    configurations: [
        .debug(
            name: .debug,
            xcconfig: .relativeToRoot("Configs/Scrumdinger.xcconfig")
        ),
        .release(
            name: .release,
            xcconfig: .relativeToRoot("Configs/Scrumdinger.xcconfig")
        )
    ]
)

let project = Project(
    name: projectName,
    organizationName: organizationName,
    options: .options(
        automaticSchemesOptions: .disabled,
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    packages: [],
    settings: settings,
    targets: [
        .init(
            name: appName,
            platform: .iOS,
            product: .app,
            bundleId: "com.havi.Scrumdinger",
            deploymentTarget: .iOS(
                targetVersion: "16.2",
                devices: [.iphone]
            ),
            sources: [
                "Sources/**"
            ],
            resources: [
                "Resources/**"
            ],
            settings: settings
        )
    ],
    schemes: [
        .init(
            name: "Scrumdinger",
            buildAction: .buildAction(targets: ["\(appName)"])
        )
    ]
)
