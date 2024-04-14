import SwiftUI
import ComposableArchitecture
import CommandsTree
import CommandsHistory

struct GaiView: View {
    @Bindable private var store: StoreOf<GaiFeature>

    init(store: StoreOf<GaiFeature>) {
        self.store = store
    }

    public var body: some View {
        HStack {
            CommandsTreeView(
                store: store.scope(state: \.commandsTree, action: \.commandsTree)
            )
            .frame(minWidth: 600, maxWidth: .infinity)

            CommandsHistoryView(
                store: store.scope(state: \.commandsHistory, action: \.commandsHistory)
            )
        }
        .onAppear {
            store.send(.viewAppeared)
        }
    }
}
