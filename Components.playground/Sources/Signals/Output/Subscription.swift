/// Represents the lifecycle of a subscription to an `Output`
public class Subscription {
    // MARK: - Static Properties
    public static var _showTotalSubscriptions = false
    public private(set) static var TotalSubscriptions: Int = 0 {
        didSet {
            guard _showTotalSubscriptions else { return }
            print("Total Subscriptions: \(TotalSubscriptions)")
        }
    }

    // MARK: - Lifecycle
    init() { Subscription.TotalSubscriptions += 1 }
    deinit { Subscription.TotalSubscriptions -= 1 }

    // MARK: - Public Functions
    public func disposed(by subscriptions: Subscriptions) {
        subscriptions.add(self)
    }
}

public extension Array where Element: Subscription {
    public func disposed(by subscriptions: Subscriptions) {
        subscriptions.add(self)
    }
}
