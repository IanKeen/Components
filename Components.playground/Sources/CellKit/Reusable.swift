import UIKit

/// A reusable component
public protocol Reusable: class {
    /// The unique identifier used by this component
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    public static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableViewCell: Reusable { }
extension UICollectionViewCell: Reusable { }
