import UIKit

public class Stylesheet {
    // MARK: - Private Properties
    private var instanceStylings: [(UIView) -> Void] = []
    private var staticStylings: [() -> Void] = []

    // MARK: - Public Properties
    public let name: String

    // MARK: - Lifecycle
    public init(name: String) {
        self.name = name
    }

    // MARK: - Public Functions
    /// Add a `Style` for a specific type to this `Stylesheet`
    public func styling<T>(_: T.Type, with style: Style<T>) -> Stylesheet {
        let instanceStyling = { (view: UIView) in
            let matchingViews = view.subviews(of: T.self)
            matchingViews.forEach(style.style)
        }
        instanceStylings.append(instanceStyling)

        let staticStyling = {
            T.styleAll(with: style)
        }
        staticStylings.append(staticStyling)

        return self
    }

    /// Apply this `Stylesheet` to the provided `UIView` and its subviews
    public func apply(to parent: UIView, animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.35 : 0.0) {
            for styling in self.instanceStylings {
                styling(parent)
            }
        }
    }

    /// Apply this `Stylesheet` to all `UIView` instances added to this sheet.
    ///
    /// - Note: This method uses `UIAppearance` so only supported properties will work.
    ///         Also, this won't apply to a `UIViewController`s root view. It appears to be
    //          a limitation with `UIAppearance`
    public func applyToAll() {
        for styling in self.staticStylings {
            styling()
        }
    }
}

public extension Styleable where Self: UIView {
    /// Apply styles from the provided `Stylesheet` to the receiver
    public func style(using stylesheet: Stylesheet) -> Self {
        stylesheet.apply(to: self)
        return self
    }
}

private extension UIView {
    func subviews<T>(of _: T.Type) -> [T] {
        var result: [T] = []

        if let view = self as? T {
            result.append(view)
        }

        for view in subviews {
            if let view = view as? T {
                result.append(view)
            }

            // only dig deeper into plain `UIView`s
            // otherwise it can mess up labels within buttons for example
            guard type(of: view) == UIView.self else { continue }

            result.append(contentsOf: view.subviews(of: T.self))
        }

        return result
    }
}
