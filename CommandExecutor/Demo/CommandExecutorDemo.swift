import SwiftUI
import AppKit
import CommandExecutor

@main
struct CommandExecutorDemo: App {

    let aiCommand = "ai"

    let indepCommand = "swift run -- indep modularity-metrics --modules Abuses --console"
    let indepDirectory = "~/avito-ios/avito-project-gen/"

    let swiftFormatCommand = "swift-format"
    let swiftFormatDirectory = "~/avito-ios/"

    let commandExecutor = CommandExecutor()

    var body: some Scene {
        WindowGroup {

            Button(action: {
                commandExecutor.run(aiCommand, in: nil)
            }) {
                Text("Run ai")
            }
            .frame(width: 300, height: 100)

            Button(action: {
                commandExecutor.run(indepCommand, in: indepDirectory)
            }) {
                Text("Run Indep in \(indepDirectory)")
            }
            .frame(width: 300, height: 100)

            Button(action: {
                commandExecutor.run(swiftFormatCommand, in: swiftFormatDirectory)
            }) {
                Text("Run swift-format in \(swiftFormatDirectory)")
            }
            .frame(width: 300, height: 100)
        }
    }
}
