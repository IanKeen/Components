/// An object that can be cancelled
public protocol Cancellable {
    /// Cancel the operation/task
    func cancel()
}

public struct NoopCancellable: Cancellable {
    public init() { }
    public func cancel() { }
}
