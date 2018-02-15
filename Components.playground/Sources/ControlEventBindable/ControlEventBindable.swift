import UIKit

public protocol ControlEventBindable: class { }

extension UIControl: ControlEventBindable { }
extension UIBarButtonItem: ControlEventBindable { }

private struct Keys {
    static var EventHandlers = "_EventHandlers"
}

// MARK: - Implementation
public extension ControlEventBindable where Self: UIControl {
    private var eventHandlers: [ControlEventHandler<Self>] {
        get { return (objc_getAssociatedObject(self, &Keys.EventHandlers) as? [ControlEventHandler<Self>]) ?? [] }
        set { objc_setAssociatedObject(self, &Keys.EventHandlers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Listen for `UIControlEvents` executing the provided closure when triggered
    public func on(_ events: UIControlEvents, call closure: @escaping (Self) -> Void) {
        let handler = ControlEventHandler<Self>(sender: self, events: events, closure: closure)
        self.eventHandlers.append(handler)
    }
}

private final class ControlEventHandler<Sender: UIControl>: NSObject {
    let closure: (Sender) -> Void

    init(sender: Sender, events: UIControlEvents, closure: @escaping (Sender) -> Void) {
        self.closure = closure
        super.init()

        sender.addTarget(self, action: #selector(self.action), for: events)
    }

    @objc private func action(sender: UIControl) {
        guard let sender = sender as? Sender else { return }

        self.closure(sender)
    }
}
