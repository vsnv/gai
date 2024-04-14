/// Структура с мтубельными аргументами для ввода значений аргументов без необходимость постоянно пересоздавать иммутабельные структуры.
public struct CommandForArgsInput: Identifiable, Equatable, Codable {

    public var id: String { stringToExecute }

    public let command: Command

    public var argsStorage: MutableCommandArgsStorage

    public var stringToExecute: String {
        let argumentsString = argsStorage.arguments.map { "\($0.value)" }.joined(separator: " ")

        let optionsWithValueString = argsStorage.options
            .filter{ !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { "\($0.key.longFlag) \($0.value)" }.joined(separator: " ")

        var flagsToInclude = [String]()
        for flag in command.flags {
            if let flagValues = argsStorage.flags[flag] {
                for (flagValue, isSelected) in flagValues where isSelected {
                    flagsToInclude.append(flagValue.longName)
                }
            }
        }

        let flagsString = flagsToInclude.joined(separator: " ")

        let stringToExecuteComponents = [
            command.path,
            argumentsString,
            optionsWithValueString,
            flagsString
        ]

        let stringToExecute = stringToExecuteComponents.filter { !$0.isEmpty }.joined(separator: " ")

        return stringToExecute
    }

    public init(
        command: Command,
        argsStorage: MutableCommandArgsStorage
    ) {
        self.command = command
        self.argsStorage = argsStorage
    }

    public init(command: Command) {
        self.command = command
        self.argsStorage = MutableCommandArgsStorage(command: command)
    }

    public init(commandInHistory: CommandInHistory) {
        self.command = commandInHistory.command
        self.argsStorage = .init(argsStorage: commandInHistory.argsStorage)
    }
}
