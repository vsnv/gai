import CommandsModels

final class CommandHelpParser {
    private let argumentParser = ArgumentsParser()
    private let optionsParser = OptionsParser()
    private let subcommandsParser = SubcommandsParser()
    private let flagsParser = FlagsParser()

    func parse(commandHelp: String) -> ParsedCommandHelp? {
        let sections = commandHelp.components(separatedBy: "\n\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        var overview: String?
        var usage: String?
        var options: [CommandOption] = []
        var subcommandsNames: [String] = []
        var arguments: [CommandArgument] = []
        var flags: [CommandFlag] = []

        let argumentsHeader = "ARGUMENTS:"
        let optionsHeader = "OPTIONS:"
        let subcommandsHeader = "SUBCOMMANDS:"

        for section in sections {
            if section.starts(with: "OVERVIEW:") {
                overview = section.replacingOccurrences(of: "OVERVIEW: ", with: "")
            } else if section.starts(with: "USAGE:") {
                usage = section.replacingOccurrences(of: "USAGE: ", with: "")
            } else if section.starts(with: optionsHeader) {
                options = optionsParser.parse(optionsHelp: sectionWithoutHeader(section, header: optionsHeader))
                flags = flagsParser.parse(optionsHelp: sectionWithoutHeader(section, header: optionsHeader))
            } else if section.starts(with: subcommandsHeader) {
                subcommandsNames = subcommandsParser.parse(subcommandsHelp: sectionWithoutHeader(section, header: subcommandsHeader))
            } else if section.starts(with: argumentsHeader) {
                arguments = argumentParser.parse(argumentsHelp: sectionWithoutHeader(section, header: argumentsHeader))
            }
        }

        guard let usage else { return nil }

        return .init(
            usage: usage,
            overview: overview,
            options: options,
            flags: flags,
            subcommandsNames: subcommandsNames,
            arguments: arguments
        )
    }

    private func sectionWithoutHeader(_ sectionWithHeader: String, header: String) -> String {
        sectionWithHeader.components(separatedBy: "\n").drop(while: { line in
            line.contains(header)
        }).joined(separator: "\n")
    }
}
