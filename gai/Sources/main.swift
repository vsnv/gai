import AppKit
import ArgumentParser

struct LaunchArgs: ParsableArguments {
    @Argument(
        help: "Рутовая команда, для которой строим UI. Например, `ai`."
    )
    var rootCommand: String

    @Option(
        name: .shortAndLong,
        help: "Директория, в которой должны выполняться команды."
    )
    var directory: String?
//
//    @Option(
//        help: "Директория, в которой должны выполняться команды, которые необходимо распарсить"
//    )
//    var parseDirectory: String?
}

final class MainCommand: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        abstract: "🚓🚓🚓🚓",
        usage: "gai <root-command>",
        subcommands: []
    )

    @OptionGroup var args: LaunchArgs

    func run() {
        let app = NSApplication.shared
        let delegate = AppDelegate(launchArgs: args)
        app.delegate = delegate
        app.run()
    }
}

MainCommand.main()
