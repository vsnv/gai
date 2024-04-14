import Foundation

public struct CommandOption: Identifiable, Equatable, Codable, Hashable {
    public var id: String { name }
    public var name: String { longFlag }
    public let longFlag: String
    public let shortFlag: String?
    public let description: String?
    public let hasValue: Bool

    public init(
        longFlag: String,
        shortFlag: String? = nil,
        description: String?,
        hasValue: Bool
    ){
        self.shortFlag = shortFlag
        self.longFlag = longFlag
        self.description = description
        self.hasValue = hasValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
