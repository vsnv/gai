// swift-tools-version:5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "gai",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        // MARK: - gai
        .executable(
            name: "gai",
            targets: ["gai"]),
        // MARK: - CommandExecutor
        .executable(
            name: "CommandExecutorDemo",
            targets: ["CommandExecutorDemo"])
    ],
    dependencies: [
        .package(
          url: "https://github.com/pointfreeco/swift-composable-architecture",
          from: "1.0.0"
        ),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
    ],
    targets: [
        // MARK: - gai
        .executableTarget(
            name: "gai",
            dependencies: [
                "CommandsTree",
                "CommandsHistory",
                "CommandExecutor",
                "CommandsTreeParser",
                "StatePersistence",
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                ),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "gai/Sources"
        ),
        // MARK: - CommandsTree
        .target(
            name: "CommandsTree",
            dependencies: [
                "CommandsModels",
                "CommandArguments",
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                )
            ],
            path: "CommandsTree/Sources"
        ),
        // MARK: - CommandArguments
        .target(
            name: "CommandArguments",
            dependencies: [
                "CommandsModels",
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                )
            ],
            path: "CommandArguments/Sources"
        ),
        // MARK: - CommandsHistory
        .target(
            name: "CommandsHistory",
            dependencies: [
                "CommandsModels",
                "CommandArguments",
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                )
            ],
            path: "CommandsHistory/Sources"
        ),
        // MARK: - CommandsModels
        .target(
            name: "CommandsModels",
            path: "CommandsModels/Sources"
        ),
        // MARK: - CommandExecutor
        .target(
            name: "CommandExecutor",
            dependencies: [
                "CommandsModels",
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                )
            ],
            path: "CommandExecutor/Sources"
        ),
        .executableTarget(
            name: "CommandExecutorDemo",
            dependencies: [
                "CommandExecutor"
            ],
            path: "CommandExecutor/Demo"
        ),
        // MARK: - CommandsTreeParser
        .target(
            name: "CommandsTreeParser",
            dependencies: [
                "CommandsModels",
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                )
            ],
            path: "CommandsTreeParser/Sources"
        ),
        .testTarget(
            name: "CommandsTreeParserTests",
            dependencies: ["CommandsTreeParser"],
            path: "CommandsTreeParser/Tests"
        ),
        // MARK: - StatePersistence
        .target(
            name: "StatePersistence",
            dependencies: [
                .product(
                  name: "ComposableArchitecture",
                  package: "swift-composable-architecture"
                )
            ],
            path: "StatePersistence/Sources"
        )
    ]
)

