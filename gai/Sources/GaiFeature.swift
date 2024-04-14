import ComposableArchitecture
import Dependencies
import CommandsHistory
import CommandsModels
import CommandsTree
import CommandsTreeParser
import StatePersistence

@Reducer
public struct GaiFeature {

    @ObservableState
    public struct State: Equatable, Codable {
        public var commandsTree: CommandsTreeFeature.State = .init()
        public var commandsHistory: CommandsHistoryFeature.State = .init()

        public var rootCommandParameter: String?
    }

    public enum Action {
        case commandsTree(CommandsTreeFeature.Action)
        case commandsHistory(CommandsHistoryFeature.Action)

        case appLaunched(rootCommandParameter: String)
        case viewAppeared
        case commandsTreeParsed(Command)
        case failedToParse(rootCommandParameter: String)
        case appWillTerminate
    }

    @Dependency(\.statePersistence) var statePersistence: StatePersistence
    @Dependency(\.commandsTreeParser) var commandsTreeParser: CommandsTreeParser

    public var body: some Reducer<State, Action> {
        Scope(state: \.commandsTree, action: \.commandsTree) {
            CommandsTreeFeature()
        }
        Scope(state: \.commandsHistory, action: \.commandsHistory) {
            CommandsHistoryFeature()
        }
        Reduce { state, action in
            switch action {
            case .appLaunched(let rootCommandParameter):
                state = State()
                state.rootCommandParameter = rootCommandParameter
                if let persistedState = try? statePersistence.read(State.self, forKey: rootCommandParameter) {
                    state = persistedState
                }
                return .none
            case .viewAppeared:
                guard let rootCommandParameter = state.rootCommandParameter else { return .none }
                return .run { send in
                    if let parsedTreeRootCommand = await commandsTreeParser.parseTree(fromRootCommand: rootCommandParameter) {
                        await send(.commandsTreeParsed(parsedTreeRootCommand))
                    } else {
                        await send(.failedToParse(rootCommandParameter: rootCommandParameter))
                    }
                }
            case .commandsTreeParsed(let parsedTreeRootCommand):
                if state.commandsTree.rootCommand != parsedTreeRootCommand {
                    state.commandsTree.rootCommand = parsedTreeRootCommand
                }
                return .none
            case .appWillTerminate:
                guard let rootCommandParameter = state.rootCommandParameter else { return .none }
                statePersistence.write(state, forKey: rootCommandParameter)
                return .none

            case .commandsTree(let commandsTreeAction):
                switch commandsTreeAction {
                case .commandArguments(.presented(let commandArgumentsAction)):
                    switch commandArgumentsAction {
                    case .executeCommandTapped(let commandToExecute):
                        return .run { send in
                            await send(.commandsHistory(.addCommandToHistory(.init(commandForArgsInput: commandToExecute))))
                        }
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .failedToParse:
                return .none
            default:
                return .none
            }
        }
    }
}
