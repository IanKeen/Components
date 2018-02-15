import Foundation

/// Blocks code from executing while an operation is already in progress
class Barrier {
    // MARK: - Private Properties
    private let queue = DispatchQueue(label: "barrier.queue")

    // MARK: - Public Properties
    public private(set) var active: Bool = false

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func whenAllowed(_ closure: (Barrier) -> Void) -> Void {
        let allowed: Bool = queue.sync {
            guard !active else { return false }
            active = true
            return true
        }
        if allowed {
            closure(self)
        }
    }
    public func release() {
        queue.sync {
            active = false
        }
    }
}
