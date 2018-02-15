/// An object that manages the lifetime of a collection of `Subscription`s
public class Subscriptions {
    // MARK: - Properties
    private let queue = DispatchQueue(label: "subscriptions.queue")
    private var subscriptions: [Subscription] = []
    private let min: Int
    private let max: Int

    // MARK: - Lifecycle
    public init(min: Int = 0, max: Int = .max) {
        self.min = min
        self.max = max
    }
    deinit {
        clear()
    }

    // MARK: - Public Functions
    public func add(_ subscription: Subscription) {
        add([subscription])
    }
    public func add(_ newSubscriptions: [Subscription]) {
        queue.sync {
            subscriptions.append(contentsOf: newSubscriptions)
            checkBounds()
        }
    }
    public func clear() {
        queue.sync {
            subscriptions = []
            checkBounds()
        }
    }

    // MARK: - Private Functions
    private func checkBounds() {
        if subscriptions.count > max {
            print("WARNING: The number of subscriptions (\(subscriptions.count) have exceeded the provided max (\(max)")
        } else if subscriptions.count < min {
            print("WARNING: The number of subscriptions (\(subscriptions.count) have dropped below the provided min (\(min)")
        }
    }
}


