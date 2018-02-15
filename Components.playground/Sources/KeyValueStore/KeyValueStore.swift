/// Represents an object that stores values with a provided key
public protocol KeyValueStore: class {
    /// Closure that is called when the `KeyValueStorage` is updated
    var onUpdate: ((KeyValueStore, String) -> Void)? { get set }

    /// Obtain a value for the provided key
    ///
    /// - Parameter key: The key containing the value
    /// - Returns: The stored value for the provided key if it exists, otherwise nil
    func value<T: Codable>(for key: String) -> T?

    /// Update a value for the provided key
    ///
    /// - Parameters:
    ///   - setting: The key to update
    ///   - value: The new value for the key
    func update<T: Codable>(_ key: String, to value: T?)
}
