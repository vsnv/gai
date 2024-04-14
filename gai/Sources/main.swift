import AppKit
import ArgumentParser

final class MainCommand: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        abstract: "🚓🚓🚓🚓",
        usage: "gai <root-command>",
        subcommands: []
    )

    @Argument(
        help: "Рутовая команда, для которой строим UI. Например, `ai`."
    )
    var rootCommand: String

    func run() {
        let app = NSApplication.shared
        let delegate = AppDelegate(rootCommandParameter: rootCommand)
        app.delegate = delegate
        app.run()
    }
}

MainCommand.main()
