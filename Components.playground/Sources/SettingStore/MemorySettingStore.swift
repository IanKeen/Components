/// An in-memory `SettingStore`
public class MemorySettingStore: SettingStore {
    // MARK: - Private Properties
    private var values: [String: Any] = [:]

    // MARK: - Public Properties
    public var onUpdate: ((SettingStore) -> Void)?

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func value<T>(for setting: Setting<T>) -> T {
        guard let value = values[setting.key] as? T else { return setting.default }
        return value
    }
    public func update<T>(_ setting: Setting<T>, to value: T) {
        values[setting.key] = value
        onUpdate?(self)
    }
}

