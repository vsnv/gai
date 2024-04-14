import Foundation
import Dependencies

public final class StatePersistence {

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func write(_ state: Codable, forKey key: String) {
        if let encodedState = try? JSONEncoder().encode(state) {
            userDefaults.set(encodedState, forKey: key)
        }
    }

    public func read<T>(_ type: T.Type, forKey key: String) throws -> T? where T : Decodable {
        if let savedState = userDefaults.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(type, from: savedState)
        }
        return nil
    }
}

extension StatePersistence {
    static let live = StatePersistence()
}

private enum StatePersistenceKey: DependencyKey {
  static let liveValue = StatePersistence.live
}

extension DependencyValues {
  public var statePersistence: StatePersistence {
    get { self[StatePersistenceKey.self] }
    set { self[StatePersistenceKey.self] = newValue }
  }
}
