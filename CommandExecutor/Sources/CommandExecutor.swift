import Foundation
import Dependencies

public final class CommandExecutor {

    public init() {}

    @discardableResult
    public func run(_ string: String, in directory: String?) -> String? {

        let stringToExecute: String
        if let directory = directory {
            stringToExecute = "cd " + directory + " && " + string
        } else {
            stringToExecute = string
        }

        let script = """
        tell application "Terminal"
            activate

            do script "\(stringToExecute)"
        end tell
        """

        print("Executing: \(script)")

        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.standardError = pipe

        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", script]

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)
        } catch {
            print("Ошибка при запуске терминала: \(error)")
            return nil
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
