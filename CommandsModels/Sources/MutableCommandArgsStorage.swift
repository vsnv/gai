/// Мутабельное хранилище значений аргумкентов для `CommandForArgsInput`
public struct MutableCommandArgsStorage: Equatable, Codable {

    public var arguments: [CommandArgument: String]
    public var options: [CommandOption: String]
    public var flags: [CommandFlag: [CommandFlag.Value: Bool]]

    public init(command: Command) {
        self.arguments = command.arguments.reduce(into: [CommandArgument: String](), { partialResult, argument in
            partialResult[argument] = ""
        })
        self.options = command.options.reduce(into: [CommandOption: String](), { partialResult, argument in
            partialResult[argument] = ""
        })
        self.flags = command.flags.reduce(into: [CommandFlag: [CommandFlag.Value: Bool]](), { partialResult, argument in
            partialResult[argument] = [:]
        })
    }

    public init(
        arguments: [CommandArgument : String],
        options: [CommandOption : String],
        flags: [CommandFlag : [CommandFlag.Value : Bool]]
    ) {
        self.arguments = arguments
        self.options = options
        self.flags = flags
    }

    public init(argsStorage: CommandArgsStorage) {
        self.arguments = argsStorage.arguments
        self.options = argsStorage.options
        self.flags = argsStorage.flags
    }

    public mutating func setArgumentValue(_ value: String, for argument: CommandArgument) {
        self.arguments[argument] = value
    }

    public mutating func setOptionValue(_ value: String, for option: CommandOption) {
        self.options[option] = value
    }

    public mutating func setFlagValue(_ value: Bool, flagValue: CommandFlag.Value, for flag: CommandFlag) {
        for flagValue in flag.values {
            flags[flag]?[flagValue] = false
        }
        flags[flag]?[flagValue] = value
    }
}
