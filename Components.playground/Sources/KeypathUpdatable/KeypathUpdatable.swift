import Foundation

public protocol KeypathUpdatable {
    func update<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self
}

public extension KeypathUpdatable {
    public func update<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
