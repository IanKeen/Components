import Foundation

public class UserDefaultsKeyValueStore: KeyValueStore {
    // MARK: - Private Properties
    private let userDefaults: UserDefaults

    // MARK: - Public Properties
    public var onError: ((Error) -> Void)?
    public var onUpdate: ((KeyValueStore, String) -> Void)?

    // MARK: - Lifecycle
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Public Functions
    public func value<T: Codable>(for key: String) -> T? {
        guard
            let data = userDefaults.data(forKey: userDefaultsKey(key)),
            let value = try? JSONDecoder().decode(Box<T>.self, from: data)
            else { return nil }

        return value.value
    }
    public func update<T: Codable>(_ key: String, to value: T) {
        do {
            let box = Box(value: value)
            let encoded = try JSONEncoder().encode(box)
            userDefaults.set(encoded, forKey: userDefaultsKey(key))
            onUpdate?(self, key)

        } catch let error {
            onError?(error)
            print("ERROR", error)
        }
    }

    // MARK: - Private Functions
    private func userDefaultsKey(_ key: String) -> String {
        return "KeyValueStore:\(key)"
    }
}

private struct Box<T: Codable>: Codable {
    let value: T
}
