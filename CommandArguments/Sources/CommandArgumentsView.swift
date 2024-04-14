import ComposableArchitecture
import SwiftUI
import CommandsModels

fileprivate enum Constants {
    static let leftSideWidth: CGFloat = 250
}

public struct CommandArgumentsView: View {
    @Environment(\.presentationMode) var presentationMode
    private let store: StoreOf<CommandArgumentsFeature>

    public init(store: StoreOf<CommandArgumentsFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(store.commandWithArgs.command.arguments, id: \.name) { argument in
                    ArgumentRow(argument: argument, store: store)
                }

                ForEach(store.commandWithArgs.command.options, id: \.id) { option in
                    OptionRow(option: option, store: store)
                }

                ForEach(store.commandWithArgs.command.flags, id: \.id) { flag in
                    Flag(flag: flag, store: store)
                }

                ActionButtons(presentationMode: presentationMode, store: store)
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct ArgumentRow: View {
    var argument: CommandArgument
    var store: StoreOf<CommandArgumentsFeature>

    var body: some View {
        HStack {
            TextField(
                "\(argument.name)", text: Binding(
                    get: {
                        store.commandWithArgs.argsStorage.arguments[argument] ?? ""
                    },
                    set: {
                        store.send(.setArgument(store.commandWithArgs.command, argument, $0))
                    }
                )
            )
            .frame(width: Constants.leftSideWidth)

            Text("\(argument.name)\n\(argument.description)")
                .foregroundColor(.gray)
        }
        .padding(.bottom)
    }
}

struct OptionRow: View {
    var option: CommandOption
    var store: StoreOf<CommandArgumentsFeature>

    var body: some View {
        HStack {
            TextField(
                option.longFlag, text: Binding(
                    get: { store.commandWithArgs.argsStorage.options[option] ?? "" },
                    set: { store.send(.setOption(store.commandWithArgs.command, option, $0)) }
                )
            )
            .frame(width: Constants.leftSideWidth)

            Text("\(option.name)\n\(option.description ?? "")")
                .foregroundColor(.gray)

        }
        .padding(.bottom)
    }
}

struct Flag: View {
    var flag: CommandFlag
    var store: StoreOf<CommandArgumentsFeature>

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ForEach(flag.values, id: \.id) { flagValue in
                    Toggle(isOn: Binding(
                        get: { store.commandWithArgs.argsStorage.flags[flag]?[flagValue] ?? false },
                        set: { store.send(.setFlag(store.commandWithArgs.command, flag, flagValue, $0)) }
                    )) {
                        Text("\(flagValue.longName)").frame(alignment: .leading)
                    }
                }
            }.frame(width: Constants.leftSideWidth, alignment: .leading)
            Text("\(flag.description)")
                .foregroundColor(.gray)
                .frame(maxWidth: 600, alignment: .leading)
        }
        .frame(alignment: .leading)
        .padding(.bottom)
    }
}

struct ActionButtons: View {
    @Binding var presentationMode: PresentationMode
    var store: StoreOf<CommandArgumentsFeature>

    var body: some View {
        HStack {
            Button("Cancel") {
                presentationMode.dismiss()
            }
            .keyboardShortcut(.cancelAction)

            Spacer()

            Button("Execute") {
                store.send(.executeCommandTapped(store.commandWithArgs))
                presentationMode.dismiss()
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
