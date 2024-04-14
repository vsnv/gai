import Foundation
import CommandsModels

class FlagsParser {
    func parse(optionsHelp: String) -> [CommandFlag] {
        let lines = filterLines(lines: optionsHelp.components(separatedBy: "\n"))
        let flags = parseFlags(lines: lines)
        return flags
    }

    func parseFlags(lines: [String]) -> [CommandFlag] {
        var flags = [CommandFlag]()

        for line in lines {
            guard !line.hasPrefix("    ") else {
                if var last = flags.popLast() {
                    if last.description == "" {
                        last.description += line.trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        last.description += "\n" + line.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    flags.append(last)
                }
                continue
            }

            let values = splitOptionString(optionString: line)

            var commandFlagValues = [CommandFlag.Value]()

            for value in values {
                guard let longName = extractLongName(from: value) else {
                    continue
                }
                let shortName = extractShortName(from: value)
                let commandFlagValue = CommandFlag.Value(longName: longName, shortName: shortName)
                commandFlagValues.append(commandFlagValue)
            }

            let description = extractDescription(from: line)

            let flag = CommandFlag(
                values: commandFlagValues,
                description: description ?? ""
            )
            flags.append(flag)
        }

        return flags
    }

    func splitOptionString(optionString: String) -> [String] {
        let multiValues = optionString.split(separator: "/")
        if multiValues.count > 1 {
            return multiValues.map { String($0.trimmingCharacters(in: .whitespaces)) }
        } else {
            return optionString.split(separator: "   ").map { String($0.trimmingCharacters(in: .whitespaces)) }
        }
    }

    // Функция для извлечения longName
    func extractLongName(from value: String) -> String? {
        let pattern = "--(\\w[-\\w]*)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = value as NSString
        let matches = regex?.matches(in: value, options: [], range: NSRange(location: 0, length: nsString.length))
        guard let match = matches?.first else { return nil }
        if match.numberOfRanges > 1 {
            let range = match.range(at: 1)
            return "--" + nsString.substring(with: range)
        }
        return nil
    }

    func extractShortName(from value: String) -> String? {
        let pattern = "\\s-(\\w)(?!-)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = value as NSString
        let matches = regex?.matches(in: value, options: [], range: NSRange(location: 0, length: nsString.length))
        guard let match = matches?.first else { return nil }
        if match.numberOfRanges > 1 {
            let range = match.range(at: 1)
            return nsString.substring(with: range)
        }
        return nil
    }

    func extractDescription(from optionString: String) -> String? {
        let split = optionString.split(separator: "   ").last.map { String($0.trimmingCharacters(in: .whitespaces)) }
        if let split {
            if split.contains("--") {
                return nil
            } else {
                return split
            }
        } else {
            return nil
        }
    }

    func filterLines(lines: [String]) -> [String] {
        var filteredLines = [String]()
        var previousLineStartsWithSpaces = false

        for line in lines {
            let containsAngleBrackets = line.contains("<") && line.contains(">")
            let startsWithSpaces = line.hasPrefix("    ")

            if !containsAngleBrackets && !(startsWithSpaces && (previousLineStartsWithSpaces || containsAngleBrackets)) {
                filteredLines.append(line)
            }

            previousLineStartsWithSpaces = startsWithSpaces
        }

        return filteredLines
    }
}
