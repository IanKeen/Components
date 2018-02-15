import Foundation

/// Encapsulates a function that may take time to complete.
/// Subsequent attempts to execute the function are ignored while it is running
public class Input<T> {
    public typealias InputUnlock = () -> Void
    public typealias InputFunction = (_ value: T, _ unlock: @escaping InputUnlock) -> Void

    // MARK: - Private Properties
    private let function: InputFunction
    private let barrier = Barrier()

    // MARK: - Public Properties
    /// `Output` that emits `true` when this `Input`s function is executing, `false` when it isn't
    public let working: Output<Bool>

    // MARK: - Lifecycle
    /// Create a new `Input` instance
    ///
    /// - Parameter function: Function to run when `execute` is called
    public required init(_ function: @escaping InputFunction) {
        let (output, update) = Output<Bool>.create()

        self.function = { value, unlock in
            update(true)
            function(value) {
                unlock()
                update(false)
            }
        }

        self.working = output.starting(with: false)
    }

    // MARK: - Public Functions
    /// Attempt to execute the underlying function, if the function is currently running this request is ignored.
    ///
    /// - Parameters:
    ///   - deliveryQueue: `DispatchQueue` to execute the command on, defaults to `.main`
    ///   - value: Value to pass to the function
    public func execute(on deliveryQueue: DispatchQueue = .main, value: T) {
        barrier.whenAllowed { barrier in
            deliveryQueue.async {
                self.function(value, barrier.release)
            }
        }
    }
}
