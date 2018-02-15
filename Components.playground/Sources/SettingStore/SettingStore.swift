import Foundation

/// Represents a `Setting` that can be used with a `SettingStore`
public struct Setting<T: Codable> {
    /// The unique key used to identify this `Setting`
    public let key: String

    /// The default value to use if this `Setting` isn't present in the target `SettingStore`
    public let `default`: T

    /// Creates a new `Setting`
    public init(key: String, `default`: T) {
        self.key = key
        self.`default` = `default`
    }
    
    public static func ==<T>(lhs: Setting<T>, rhs: Setting<T>) -> Bool {
        return lhs.key == rhs.key
    }
}

/// Represents an object that handles storing and vending `Setting`s
public protocol SettingStore: class {
    /// Closure that is called when the `SettingStore` is updated
    var onUpdate: ((SettingStore) -> Void)? { get set }

    /// Obtain a value for the provided `Setting`
    ///
    /// - Parameter setting: The `Setting` whose value to obtain
    /// - Returns: The stored value for the `Setting` if it exists, otherwise the `Setting`s default
    func value<T>(for setting: Setting<T>) -> T

    /// Update a value for the provided `Setting`
    ///
    /// - Parameters:
    ///   - setting: The `Setting` to update
    ///   - value: The new value for the `Setting`
    func update<T>(_ setting: Setting<T>, to value: T)
}
