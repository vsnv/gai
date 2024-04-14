import Foundation
import CommandsModels

class OptionsParser {
    func parse(optionsHelp: String) -> [CommandOption] {
        let lines = filterLines(lines: optionsHelp.components(separatedBy: "\n"))
        var options: [CommandOption] = []
        var currentOptionDescription = ""

        for line in lines {
            if line.starts(with: "  --") || line.starts(with: "  -") {
                if !currentOptionDescription.isEmpty {
                    let parsedOption = parseOptionLine(currentOptionDescription)
                    options.append(parsedOption)
                    currentOptionDescription = ""
                }
                currentOptionDescription += line
            } else {
                currentOptionDescription += " " + line.trimmingCharacters(in: .whitespaces)
            }
        }
        if !currentOptionDescription.isEmpty {
            let parsedOption = parseOptionLine(currentOptionDescription)
            options.append(parsedOption)
        }

        return options
    }

    private func parseOptionLine(_ line: String) -> CommandOption {
        let components = line.components(separatedBy: "  ").filter { !$0.isEmpty }
        let flagsAndValue = components[0].trimmingCharacters(in: .whitespaces)
        let description = components.dropFirst().joined(separator: " ").trimmingCharacters(in: .whitespaces)

        let hasValue = flagsAndValue.contains("<") && flagsAndValue.contains(">")
        let flags = flagsAndValue.components(separatedBy: ", ").flatMap { $0.split(separator: " ").map(String.init) }
        let longFlag = flags.first { $0.starts(with: "--") } ?? ""
        let shortFlag = flags.first { $0.starts(with: "-") && !$0.starts(with: "--") } ?? ""

        return CommandOption(longFlag: longFlag, shortFlag: shortFlag, description: description, hasValue: hasValue)
    }

    func filterLines(lines: [String]) -> [String] {
        var filteredLines = [String]()
        var previousLineStartsWithSpaces = false

        for line in lines {
            let containsAngleBrackets = line.contains("<") && line.contains(">")
            let startsWithSpaces = line.hasPrefix("    ")

            // We change the logic to include lines that contain both < and >
            if containsAngleBrackets && !(startsWithSpaces && (previousLineStartsWithSpaces || containsAngleBrackets)) {
                filteredLines.append(line)
            }

            previousLineStartsWithSpaces = startsWithSpaces
        }

        return filteredLines
    }

}
