import Foundation

public class UserDefaultsSettingStore: SettingStore {
    // MARK: - Private Properties
    private let userDefaults: UserDefaults

    // MARK: - Public Properties
    public var onError: ((Error) -> Void)?
    public var onUpdate: ((SettingStore) -> Void)?

    // MARK: - Lifecycle
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Public Functions
    public func value<T>(for setting: Setting<T>) -> T {
        guard
            let data = userDefaults.data(forKey: setting.userDefaultKey),
            let value = try? JSONDecoder().decode(Box<T>.self, from: data)
            else { return setting.default }

        return value.value
    }
    public func update<T>(_ setting: Setting<T>, to value: T) {
        do {
            let box = Box(value: value)
            let encoded = try JSONEncoder().encode(box)
            userDefaults.set(encoded, forKey: setting.userDefaultKey)
            onUpdate?(self)

        } catch let error {
            onError?(error)
            print("ERROR", error)
        }
    }
}

private struct Box<T: Codable>: Codable {
    let value: T
}

private extension Setting {
    var userDefaultKey: String {
        return "SettingStore:\(key)"
    }
}
