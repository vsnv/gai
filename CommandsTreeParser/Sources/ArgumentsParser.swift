import CommandsModels

// FIXME: Shitty Code
final class ArgumentsParser {
    func parse(argumentsHelp: String) -> [CommandArgument] {
        let lines = filterLines(lines: argumentsHelp.components(separatedBy: "\n"))
        let arguments = parseArguments(lines: lines)
        return arguments
    }

    func parseArguments(lines: [String]) -> [CommandArgument] {
        var arguments = [CommandArgument]()

        for line in lines {
            guard !line.hasPrefix("    ") else {
                if var last = arguments.popLast() {
                    if last.description == "" {
                        last.description += line.trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        last.description += "\n" + line.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    arguments.append(last)
                }
                continue
            }

            let splitParts = split(line: line)

            let name: String
            if splitParts.count > 0 {
                name = splitParts[0]
            } else {
                continue
            }

            let description: String
            if splitParts.count > 1 {
                description = splitParts[1]
            } else {
                description = ""
            }

            let argument = CommandArgument(
                name: name,
                description: description
            )

            arguments.append(argument)
        }

        return arguments
    }

    func split(line: String) -> [String] {
        line.split(separator: "   ").map { String($0.trimmingCharacters(in: .whitespaces)) }
    }

    func filterLines(lines: [String]) -> [String] {
        var filteredLines = [String]()
        var includeNextLines = false // Флаг для включения следующих строк, начинающихся с пробелов

        for line in lines {
            let containsAngleBrackets = line.contains("<") && line.contains(">")
            let startsWithSpaces = line.hasPrefix("    ")

            if containsAngleBrackets || (includeNextLines && startsWithSpaces) {
                filteredLines.append(line)
                includeNextLines = true
            } else {
                includeNextLines = false
            }
        }

        return filteredLines
    }

}

