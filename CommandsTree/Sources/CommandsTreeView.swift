import SwiftUI
import ComposableArchitecture
import CommandsModels
import CommandArguments

public struct CommandsTreeView: View {

    @Bindable private var store: StoreOf<CommandsTreeFeature>

    public init(store: StoreOf<CommandsTreeFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let rootCommand = store.rootCommand {
                    CommandView(store: store, command: rootCommand, level: 0)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(alignment: .center)
                }
            }
            .padding()
        }

        .sheet(
            item: $store.scope(state: \.commandArguments, action: \.commandArguments)
        ) { commandArgumentsStore in
            CommandArgumentsView(store: commandArgumentsStore)
        }
    }
}
