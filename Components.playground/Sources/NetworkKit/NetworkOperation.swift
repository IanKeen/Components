/// A `Cancellable` object that encapsulates another `Cancellable`.
/// Used to ensure an objects cancelled state is correct when created
/// asynchronously but made available synchronously
public final class NetworkOperation: Cancellable {
    // MARK: - Private Properties
    private var cancelled = false {
        didSet { cancelIfNeeded() }
    }

    // MARK: - Public Properties
    public var operation: Cancellable? {
        didSet { cancelIfNeeded() }
    }

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func cancel() {
        cancelled = true
    }

    // MARK: - Private Functions
    private func cancelIfNeeded() {
        guard cancelled else { return }
        operation?.cancel()
    }
}
