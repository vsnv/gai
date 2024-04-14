/// Иммутабельная структура для истории
public struct CommandInHistory: Identifiable, Equatable, Codable {
    public var id: String { stringToExecute }

    public let command: Command
    public let argsStorage: CommandArgsStorage
    public let stringToExecute: String

    public init(command: Command, argsStorage: CommandArgsStorage, stringToExecute: String) {
        self.command = command
        self.argsStorage = argsStorage
        self.stringToExecute = stringToExecute
    }

    /// Делаем из мутабельной структуры для ввода аргументов иммутабельную для истории
    public init(commandForArgsInput: CommandForArgsInput) {
        self.command = commandForArgsInput.command
        self.argsStorage = .init(mutableCommandArgsStorage: commandForArgsInput.argsStorage)
        self.stringToExecute = commandForArgsInput.stringToExecute
    }
}
