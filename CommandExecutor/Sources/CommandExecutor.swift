import Foundation
import Dependencies

public final class CommandExecutor {

    public init() {}

    public func run(_ stringToExecute: String) {
        print("Executing: \(stringToExecute)")

        let script = """
        tell application "Terminal"
            activate

            do script "\(stringToExecute)"
        end tell
        """

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", script]

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            print("Ошибка при запуске терминала: \(error)")
        }
    }
}

extension CommandExecutor {
    static let live = CommandExecutor()
}

private enum CommandExecutorKey: DependencyKey {
  static let liveValue = CommandExecutor.live
}

extension DependencyValues {
  public var commandExecutor: CommandExecutor {
    get { self[CommandExecutorKey.self] }
    set { self[CommandExecutorKey.self] = newValue }
  }
}
