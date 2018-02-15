/// Represents an in-memory `KeyValueStore`
public class MemoryKeyValueStore: KeyValueStore {
    // MARK: - Private Properties
    private var values: [String: Any] = [:]

    // MARK: - Public Properties
    public var onUpdate: ((KeyValueStore, String) -> Void)?

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func value<T>(for key: String) -> T? {
        guard let value = values[key] as? T else { return nil }
        return value
    }
    public func update<T>(_ key: String, to value: T?) {
        values[key] = value
        onUpdate?(self, key)
    }
}
