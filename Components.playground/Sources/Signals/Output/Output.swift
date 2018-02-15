import Foundation

public typealias Updater<T> = (T) -> Void

public func notEquatable<T>(x: T, y: T) -> Bool { return false }

public class Output<T> {
    // MARK: - Internal Properties
    let value: Atomic<T?>
    let equality: (T, T) -> Bool

    // MARK: - Private Properties
    private let nextToken: () -> Int
    private var subscriptions: [Int: Weak<OutputSubscription>] = [:]
    private var retaining: [Any] = []

    // MARK: - Lifecycle
    init(value: T? = nil, equality: @escaping (T, T) -> Bool) {
        var iterator = (0...).makeIterator()
        self.nextToken = { iterator.next()! }
        self.value = Atomic(value)
        self.equality = equality
    }

    // MARK: - Public Functions
    public func subscribe(on queue: DispatchQueue = .main, _ closure: @escaping (T) -> Void) -> Subscription {
        return branch(retain: false, queue: queue) { closure($0) }
    }

    // MARK: - Internal Functions
    func send(_ value: T) {
        switch (self.value.value, value) {
        case (nil, _):
            break
        case (let old?, let new) where !equality(old, new):
            break
        default:
            return
        }

        self.value.update(value)
        subscriptions.values.forEach { $0.value?.closure() }
    }
    @discardableResult
    func branch(retain: Bool, queue: DispatchQueue? = nil, _ closure: @escaping (T) -> Void) -> Subscription {
        let token = nextToken()

        let subscription = OutputSubscription(
            closure: { [weak self] in
                guard let value = self?.value.value else { return }

                if let queue = queue {
                    queue.async { closure(value) }
                } else {
                    closure(value)
                }
            },
            disposed: { [weak self] in
                self?.subscriptions[token] = nil
            }
        )
        subscriptions[token] = Weak(subscription)

        if let value = value.value {
            if let queue = queue {
                queue.async { closure(value) }
            } else {
                closure(value)
            }
        }

        if retain {
            retaining.append(subscription)
        }

        return subscription
    }
}
