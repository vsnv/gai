import ComposableArchitecture
import Dependencies
import CommandsHistory
import CommandsModels
import CommandsTree
import CommandsTreeParser
import StatePersistence
import CommandExecutor

@Reducer
struct GaiFeature {

    @ObservableState
    struct State: Equatable, Codable {
        var commandsTree: CommandsTreeFeature.State = .init()
        var commandsHistory: CommandsHistoryFeature.State = .init()

        var rootCommandArgument: String?
        var directory: String?
    }

    enum Action {
        case commandsTree(CommandsTreeFeature.Action)
        case commandsHistory(CommandsHistoryFeature.Action)

        case appLaunched(with: LaunchArgs)
        case viewAppeared
        case commandsTreeParsed(Command)
        case failedToParse(rootCommandParameter: String)
        case appWillTerminate
        case execute(String)
    }

    @Dependency(\.statePersistence) var statePersistence: StatePersistence
    @Dependency(\.commandsTreeParser) var commandsTreeParser: CommandsTreeParser
    @Dependency(\.commandExecutor) var commandExecutor: CommandExecutor

    var body: some Reducer<State, Action> {
        Scope(state: \.commandsTree, action: \.commandsTree) {
            CommandsTreeFeature()
        }
        Scope(state: \.commandsHistory, action: \.commandsHistory) {
            CommandsHistoryFeature()
        }
        Reduce { state, action in
            switch action {
            case .appLaunched(let launchArgs):
                state = State()
                if let persistedState = try? statePersistence.read(State.self, forKey: launchArgs.rootCommand) {
                    state = persistedState
                }
                state.rootCommandArgument = launchArgs.rootCommand
                state.directory = launchArgs.directory
                return .none
            case .viewAppeared:
                guard let rootCommandParameter = state.rootCommandArgument else { return .none }
                let directory = state.directory
                return .run { send in
                    let parsedTreeRootCommand = await commandsTreeParser.parseTree(
                        fromRootCommand: rootCommandParameter,
                        in: directory
                    )
                    await send(.commandsTreeParsed(parsedTreeRootCommand))
                }
            case .commandsTreeParsed(let parsedTreeRootCommand):
                if state.commandsTree.rootCommand != parsedTreeRootCommand {
                    state.commandsTree.rootCommand = parsedTreeRootCommand
                }
                return .none
            case .appWillTerminate:
                guard let rootCommandParameter = state.rootCommandArgument else { return .none }
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
                case .execute(let command):
                    commandExecutor.run(command.stringToExecute, in: state.directory)
                    return .none
                default:
                    return .none
                }
            case .commandsHistory(let commandsHistoryAction):
                switch commandsHistoryAction {
                case .execute(let command):
                    commandExecutor.run(command.stringToExecute, in: state.directory)
                    return .none
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
