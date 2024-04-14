/// Ридонли хранилище аргументов и их значений
public struct CommandArgsStorage: Equatable, Codable {
    public let arguments: [CommandArgument: String]
    public let options: [CommandOption: String]
    public let flags: [CommandFlag: [CommandFlag.Value: Bool]]

    public init(mutableCommandArgsStorage: MutableCommandArgsStorage) {
        self.arguments = mutableCommandArgsStorage.arguments
        self.options = mutableCommandArgsStorage.options
        self.flags = mutableCommandArgsStorage.flags
    }
}
