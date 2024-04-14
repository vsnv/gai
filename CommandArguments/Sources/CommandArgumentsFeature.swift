import ComposableArchitecture
import CommandsModels

@Reducer
public struct CommandArgumentsFeature {

    @ObservableState
    public struct State: Equatable, Codable {
        public var commandWithArgs: CommandForArgsInput

        public init(commandWithArgs: CommandForArgsInput) {
            self.commandWithArgs = commandWithArgs
        }
    }

    public enum Action {
        case setArgument(Command, CommandArgument, String)
        case setOption(Command, CommandOption, String)
        case setFlag(Command, CommandFlag, CommandFlag.Value, Bool)
        case executeCommandTapped(CommandForArgsInput)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .executeCommandTapped:
                return .none
            case .setArgument(_, let key, let value):
                state.commandWithArgs.argsStorage.setArgumentValue(value, for: key)
                return .none
            case .setOption(_, let key, let value):
                state.commandWithArgs.argsStorage.setOptionValue(value, for: key)
                return .none
            case .setFlag(_, let key, let flagValue, let isFlagOn):
                state.commandWithArgs.argsStorage.setFlagValue(isFlagOn, flagValue: flagValue, for: key)
                return .none
            }
        }
    }
}

