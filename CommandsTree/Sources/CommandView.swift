import SwiftUI
import ComposableArchitecture
import CommandsModels

struct CommandView: View {

    @Bindable var store: StoreOf<CommandsTreeFeature>

    var command: Command
    var level: Int

    var body: some View {
        HStack {
            Spacer().frame(width: CGFloat(level * 20))
            if command.subcommands.count == 0 {
                Button(action: {
                    store.send(.commandTapped(command))
                }) {
                    Text(command.path)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 5)
                .background(Color.clear)
                .cornerRadius(5)
                Text("- \(command.description)")
                    .italic()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading) {
                    Divider()
                    HStack {
                        Divider()
                        Button(action: {
                            store.send(.commandTapped(command))
                        }) {
                            Text(command.path)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 5)
                        .background(Color.clear)
                        Text("- \(command.description)")
                            .italic()
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }

        ForEach(command.subcommands) { subcommand in
            CommandView(store: store, command: subcommand, level: self.level + 1)
        }
    }
}
