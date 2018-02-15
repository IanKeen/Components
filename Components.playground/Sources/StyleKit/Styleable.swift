import UIKit

/// An element that can have a `Style` applied
public protocol Styleable: class { }

extension UIView: Styleable { }

public extension Styleable where Self: UIView {
    /// Apply the styling in the provided closure to the receiver
    public func style(_ closure: (Self) -> Void) {
        closure(self)
    }

    /// Apply the provided `Style` to the receiver
    public func style(with style: Style<Self>) {
        self.style(style.style)
    }

    /// Apply the styling in the provided closure to the receiver
    ///
    /// - Returns: The receiver
    public func styled(_ closure: (Self) -> Void) -> Self {
        self.style(closure)
        return self
    }

    /// Apply the provided `Style` to the receiver
    ///
    /// - Returns: The receiver
    public func styled(with style: Style<Self>) -> Self {
        self.style(style.style)
        return self
    }

    /// Use `UIAppearance` to apply styling to all instances of the receiving type
    ///
    /// - Note: Only `UIAppearance` supported properties will work
    public static func styleAll(_ closure: (Self) -> Void) {
        closure(appearance())
    }

    /// Use `UIAppearance` to apply the `Style` to all instances of the receiving type
    ///
    /// - Note: Only `UIAppearance` supported properties from the `Style` will work
    public static func styleAll(with style: Style<Self>) {
        style.style(appearance())
    }
}

public struct Style<T: UIView> {
    public let style: (T) -> Void

    public init(style: @escaping (T) -> Void) {
        self.style = style
    }
}

