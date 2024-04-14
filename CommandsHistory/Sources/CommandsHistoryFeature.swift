import Foundation
import ComposableArchitecture
import CommandsModels
import CommandArguments
import CommandExecutor

@Reducer
public struct CommandsHistoryFeature {

    @ObservableState
    public struct State: Equatable, Codable {
        public var commandsInHistory = [CommandInHistory]()
        public var selectedCommandInHistory: CommandInHistory?

        @Presents public var commandArguments: CommandArgumentsFeature.State?

        public init() {}
    }

    public enum Action {
        case commandTapped(CommandInHistory)
        case commandDoubleTapped(CommandInHistory)
        case commandLongTapped(CommandInHistory)

        case deleteTapped
        case executeTapped
        case configureTapped

        case deleteCommandFromHistory(CommandInHistory)
        case addCommandToHistory(CommandInHistory)

        case commandArguments(
            PresentationAction<CommandArgumentsFeature.Action>
        )
    }

    @Dependency(\.commandExecutor) var commandExecutor: CommandExecutor

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .commandTapped(let tappedCommand):
                select(tappedCommand, state: &state)
                return .none
            case .commandDoubleTapped(let command):
                commandExecutor.run(command.stringToExecute)
                return .run { send in
                    await send(.addCommandToHistory(command))
                }
            case .commandLongTapped(let command):
                showCommandArgumentsView(for: command, state: &state)
                return .none
            case .commandArguments(.presented(let commandArgumentsAction)):
                switch commandArgumentsAction {
                case .executeCommandTapped(let command):
                    commandExecutor.run(command.stringToExecute)
                    return .run { send in
                        await send(.addCommandToHistory(.init(commandForArgsInput: command)))
                    }
                default:
                    return .none
                }
            case .commandArguments(.dismiss):
                return .none
            case .deleteTapped:
                guard let selectedCommand = state.selectedCommandInHistory else { return .none }
                return .run { send in
                    await send(.deleteCommandFromHistory(selectedCommand))
                }
            case .executeTapped:
                guard let selectedCommand = state.selectedCommandInHistory else { return .none }
                commandExecutor.run(selectedCommand.stringToExecute)
                return .run { send in
                    await send(.addCommandToHistory(selectedCommand))
                }
            case .configureTapped:
                guard let selectedCommand = state.selectedCommandInHistory else { return .none }
                showCommandArgumentsView(for: selectedCommand, state: &state)
                return .none
            case .deleteCommandFromHistory(let command):
                removeFromHistory(command, state: &state)
                return .none
            case .addCommandToHistory(let command):
                moveOnTop(command, state: &state)
                return .none
            }
        }
        .ifLet(\.$commandArguments, action: \.commandArguments) {
            CommandArgumentsFeature()
        }
    }

    private func moveOnTop(_ command: CommandInHistory, state: inout State) {
        removeFromHistory(command, state: &state)
        state.commandsInHistory.insert(command, at: 0)
    }

    private func removeFromHistory(_ command: CommandInHistory, state: inout State) {
        state.commandsInHistory.removeAll {
            $0 == command
        }
    }

    private func select(_ commandWithArgs: CommandInHistory, state: inout State) {
        state.selectedCommandInHistory = commandWithArgs
    }

    private func showCommandArgumentsView(for command: CommandInHistory, state: inout State) {
        let newCommandForArgsInput = CommandForArgsInput(commandInHistory: command)
        state.commandArguments = .init(commandWithArgs: newCommandForArgsInput)
    }
}
