import Foundation
import Dependencies
import CommandsModels

// FIXME: Shitty Code
public final class CommandsTreeParser {

    struct CommandBuilder {
        var path: [String]
        var parsedHelp: ParsedCommandHelp
        var subcommandsNames: [String]
        var subcommands: [CommandBuilder]
    }

    private let commandHelpParser = CommandHelpParser()

    public init() {}

    public func parseTree(fromRootCommand rootCommand: String, in directory: String?) async -> Command {
        let value = await Task.detached {
            let builder = self.parseCommands(fromRootCommand: rootCommand, in: directory)
            let rootCommandParsed = self.mapCommandBuilderToCommandWithArgs(builder)
            return rootCommandParsed
        }.value
        return value
    }

    private func mapCommandBuilderToCommandWithArgs(_ builder: CommandBuilder) -> Command {
        Command(
            fullPath: builder.path.joined(separator: " "), 
            description: builder.parsedHelp.overview ?? "",
            arguments: builder.parsedHelp.arguments,
            options: builder.parsedHelp.options,
            flags: builder.parsedHelp.flags,
            subcommands: builder.subcommands.map { mapCommandBuilderToCommandWithArgs($0) }
        )
    }

    func parseCommands(fromRootCommand rootCommand: String, in directory: String?) -> CommandBuilder {
        print("Parsing \(rootCommand)...")
        let output = self.executeCommand(rootCommand, arguments: ["-h"], in: directory) ?? ""

        let parsedHelp = self.commandHelpParser.parse(commandHelp: output)

        let path = rootCommand.components(separatedBy: .whitespaces)

        var rootCommandParsed = CommandBuilder(
            path: path,
            parsedHelp: parsedHelp,
            subcommandsNames: parsedHelp.subcommandsNames,
            subcommands: []
        )
        if rootCommandParsed.subcommandsNames.isEmpty {
            return rootCommandParsed
        }

        if rootCommandParsed.subcommandsNames.contains(String(rootCommand.split(separator: " ").last!)) {
            return rootCommandParsed
        }

        var subcommandsParsed: [CommandBuilder] = []
        for subcommandName in rootCommandParsed.subcommandsNames {
            let newCommand = "\(rootCommand) \(subcommandName)"
            let subcommandTree = self.parseCommands(fromRootCommand: newCommand, in: directory)
            subcommandsParsed.append(subcommandTree)
        }

        subcommandsParsed.sort { (command1, command2) in
            switch (command1.subcommands.isEmpty, command2.subcommands.isEmpty) {
            case (true, false):
                return true
            case (false, true):
                return false
            case (true, true), (false, false):
                return false
            }
        }

        rootCommandParsed.subcommands = subcommandsParsed
        return rootCommandParsed
    }

    // FIXME: Юзать CommandExecutor или ваще импортнуть CLT
    private func executeCommand(
        _ command: String,
        arguments: [String] = [],
        in directory: String?
    ) -> String? {
        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.standardError = pipe
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")

        let commandWithArgs = ([command] + arguments).joined(separator: " ")
        let stringToExecute: String
        if let directory = directory {
            stringToExecute = "cd " + directory + " && " + commandWithArgs
        } else {
            stringToExecute = commandWithArgs
        }

        process.arguments = ["-c", stringToExecute]

        if let arguments = process.arguments {
            print("Executing: \(arguments)")
        }

        do {
            try process.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to execute command: \(error)")
            return nil
        }
    }
}
