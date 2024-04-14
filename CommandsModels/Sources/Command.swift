import Foundation

/// Нода дерева команд, без значений аргументов.
public struct Command: Identifiable, Equatable, Codable, Hashable {

    public static func == (lhs: Command, rhs: Command) -> Bool {
        lhs.id == rhs.id && 
        lhs.arguments == rhs.arguments &&
        lhs.options == rhs.options &&
        lhs.flags == rhs.flags &&
        lhs.subcommands == rhs.subcommands
    }

    public var id: String { path }
    public let path: String
    public let description: String
    public let arguments: [CommandArgument]
    public let options: [CommandOption]
    public let flags: [CommandFlag]
    public let subcommands: [Command]

    public init(
        fullPath: String,
        description: String,
        arguments: [CommandArgument],
        options: [CommandOption],
        flags: [CommandFlag],
        subcommands: [Command]
    ) {
        self.path = fullPath
        self.description = description
        self.arguments = arguments
        self.options = options
        self.flags = flags
        self.subcommands = subcommands
    }
}
