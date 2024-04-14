import Dependencies
import CommandsModels

extension CommandsTreeParser {
    static let live = CommandsTreeParser()
}

private enum CommandTreeParserKey: DependencyKey {
  static let liveValue = CommandsTreeParser.live
}

extension DependencyValues {
  public var commandsTreeParser: CommandsTreeParser {
    get { self[CommandTreeParserKey.self] }
    set { self[CommandTreeParserKey.self] = newValue }
  }
}
