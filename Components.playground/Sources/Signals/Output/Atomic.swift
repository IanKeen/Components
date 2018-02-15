import Foundation

private extension NSLock {
    func value<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }
}

final class Atomic<T> {
    // MARK: - Private Properties
    private let lock = NSLock()
    private var atomicValue: T

    // MARK: - Lifecycle
    init(_ value: T) {
        atomicValue = value
    }

    // MARK: - Internal Functions
    @discardableResult
    func update(_ value: T) -> T {
        lock.lock(); defer { lock.unlock() }
        atomicValue = value
        return value
    }

    var value: T {
        get { return lock.value { atomicValue } }
        set { update(newValue) }
    }
}
