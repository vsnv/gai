import Foundation

public struct CommandArgument: Identifiable, Equatable, Codable, Hashable {

    public static func == (lhs: CommandArgument, rhs: CommandArgument) -> Bool {
        lhs.name == rhs.name &&
        lhs.description == rhs.description
    }

    public var id: String { name }
    public let name: String
    public var description: String

    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
