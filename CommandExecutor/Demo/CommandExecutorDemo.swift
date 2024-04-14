import SwiftUI
import AppKit
import CommandExecutor

@main
struct CommandExecutorDemo: App {

    let demoCommand = "ai install"
    let commandRunner = CommandRunner()

    var body: some Scene {
        WindowGroup {
            Button(action: {
                commandRunner.run(stringToExecute: demoCommand)
            }) {
                Text("Run Demo Command \(demoCommand)")
            }
            .frame(width: 300, height: 100)
        }
    }
}
