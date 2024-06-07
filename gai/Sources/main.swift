import AppKit
import ArgumentParser

struct LaunchArgs: ParsableArguments {
    @Argument(
        help: "Рутовая команда, для которой строим UI."
    )
    var rootCommand: String = "ai"

    @Option(
        name: .shortAndLong,
        help: "Директория, в которой должны выполняться команды. Если не указано, будет выполнено в папке, в которой запущен сам gai"
    )
    var directory: String?
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
