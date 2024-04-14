import SwiftUI
import ComposableArchitecture
import CommandsModels
import CommandArguments

public struct CommandsHistoryView: View {

    @Bindable private var store: StoreOf<CommandsHistoryFeature>

    public init(store: StoreOf<CommandsHistoryFeature>) {
        self.store = store
    }

    public var body: some View {
        if store.commandsInHistory.isEmpty {
            ScrollView {
                Text("Тут появится история")
                    .frame(alignment: .center)
                    .padding()
            }
        } else {
            ScrollView {
                contentView
            }
            .background(Color.black)
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))

            ActionButtons(store: store)

                .sheet(
                    item: $store.scope(state: \.commandArguments, action: \.commandArguments)
                ) { commandArgumentsStore in
                    CommandArgumentsView(store: commandArgumentsStore)
                }
        }
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(store.commandsInHistory, id: \.id) { command in
                CommandCellView(command: command.stringToExecute, isSelected: store.selectedCommandInHistory == command)
                    .onTapGesture {
                        store.send(.commandTapped(command))
                    }
                    // FIXME: Если просто добавить два обработчика для одиночного и двойного тапа, то жестко тупит, поэтому нарыл какой-то костыль + обрабатываем лонг и дабл тапы только по уже выбранной ячейке
                    .overlay(
                        Group {
                            if store.selectedCommandInHistory == command {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture(count: 2) {
                                        store.send(.commandDoubleTapped(command))
                                    }
                                    .onLongPressGesture {
                                        store.send(.commandLongTapped(command))
                                    }
                            }
                        }
                    )
            }
        }
    }
}

struct CommandCellView: View {
    var command: String
    var isSelected: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                .frame(maxWidth: .infinity, minHeight: 20)
            Text(command)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ActionButtons: View {
    let store: StoreOf<CommandsHistoryFeature>

    var body: some View {
        HStack {
            Button("Delete") {
                store.send(.deleteTapped)
            }
            .disabled(store.selectedCommandInHistory == nil)
            .keyboardShortcut(.cancelAction)

            Spacer()

            Button("Configure") {
                store.send(.configureTapped)
            }
            .disabled(store.selectedCommandInHistory == nil)

            Button("Execute") {
                store.send(.executeTapped)
            }
            .disabled(store.selectedCommandInHistory == nil)
            .keyboardShortcut(.defaultAction)
        }
        .padding()
    }
}
