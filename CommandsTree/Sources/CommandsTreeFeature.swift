import ComposableArchitecture
import CommandsModels
import CommandExecutor
import CommandArguments

@Reducer
public struct CommandsTreeFeature {

    @ObservableState
    public struct State: Equatable, Codable {
        public var rootCommand: Command?

        public var commandsWithArgs = [Command: CommandForArgsInput]()

        @Presents public var commandArguments: CommandArgumentsFeature.State?

        public init(rootCommand: Command? = nil) {
            self.rootCommand = rootCommand
        }
    }

    public enum Action {
        case commandTapped(Command)
        case commandArguments(
            PresentationAction<CommandArgumentsFeature.Action>
        )
    }

    @Dependency(\.commandExecutor) var commandExecutor: CommandExecutor

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .commandTapped(let tappedCommand):
                if let existingCommandWithArgs = state.commandsWithArgs[tappedCommand] {
                    state.commandArguments = .init(commandWithArgs: existingCommandWithArgs)
                } else {
                    let newCommandWithArgs = state.commandsWithArgs[tappedCommand, default: CommandForArgsInput(command: tappedCommand)]
                    state.commandsWithArgs[tappedCommand] = newCommandWithArgs
                    state.commandArguments = .init(commandWithArgs: newCommandWithArgs)
                }
                return .none
            case .commandArguments(.presented(let commandArgumentsAction)):
                switch commandArgumentsAction {
                case .setArgument(let command, let key, let value):
                    state.commandsWithArgs[command]?.argsStorage.setArgumentValue(value, for: key)
                    return .none
                case .setOption(let command, let key, let value):
                    state.commandsWithArgs[command]?.argsStorage.setOptionValue(value, for: key)
                    return .none
                case .setFlag(let command, let key, let flagValue, let isFlagOn):
                    state.commandsWithArgs[command]?.argsStorage.setFlagValue(isFlagOn, flagValue: flagValue, for: key)
                    return .none
                case .executeCommandTapped(let commandWithArgs):
                    commandExecutor.run(commandWithArgs.stringToExecute)
                    return .none
                }
            case .commandArguments(.dismiss):
                return .none
            }
        }
        .ifLet(\.$commandArguments, action: \.commandArguments) {
            CommandArgumentsFeature()
        }
    }
}
