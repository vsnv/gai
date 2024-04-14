public struct CommandFlag: Identifiable, Equatable, Codable, Hashable {

    public struct Value: Identifiable, Equatable, Codable, Hashable {
        public var id: String { longName }
        public let longName: String
        public let shortName: String?

        public init(longName: String, shortName: String?) {
            self.longName = longName
            self.shortName = shortName
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    public static func == (lhs: CommandFlag, rhs: CommandFlag) -> Bool {
        lhs.id == rhs.id && lhs.description == rhs.description
    }

    public var id: String { values.map(\.id).joined(separator: " / ") }

    public var values: [Value]
    public var description: String

    public init(
        values: [Value],
        description: String
    ) {
        self.values = values
        self.description = description
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
