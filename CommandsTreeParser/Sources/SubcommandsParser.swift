import Foundation

final class SubcommandsParser {
    func parse(subcommandsHelp: String) -> [String] {
        let lines = subcommandsHelp.components(separatedBy: "\n")
        var parsedSubcommands = [String]()
        var currentCommand: String?

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if trimmedLine.isEmpty {
                continue
            }

            if !line.hasPrefix("    ") {
                currentCommand = trimmedLine.components(separatedBy: " ").first
                if let command = currentCommand {
                    parsedSubcommands.append(command)
                }
            }
        }
        return parsedSubcommands
    }
}
