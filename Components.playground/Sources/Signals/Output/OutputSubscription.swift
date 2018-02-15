import Foundation

class OutputSubscription: Subscription {
    // MARK: - Properties
    let closure: () -> Void
    let disposed: () -> Void

    // MARK: - Lifecycle
    init(closure: @escaping () -> Void, disposed: @escaping () -> Void) {
        self.closure = closure
        self.disposed = disposed
        super.init()
    }
    deinit {
        disposed()
    }
}
