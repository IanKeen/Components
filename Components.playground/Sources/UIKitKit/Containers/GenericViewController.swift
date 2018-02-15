import UIKit

/// A UIViewController that loads a custom UIView as its .view
/// the typed view can be accessed via the .customView property
open class GenericViewController<ViewType: UIView>: UIViewController {
    /// Provides typed access to the view controllers custom view
    public var customView: ViewType { return self.view as! ViewType }

    // MARK - Lifecycle
    open override func loadView() {
        self.view = ViewType(frame: .zero)
    }
}
