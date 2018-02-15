import UIKit

/// A `UIView` whose background cannot be clear
///
/// Useful for subviews within cells, makes it so selection doesn't interfere with the appearance
public class NeverClearView: UIView {
    public override var backgroundColor: UIColor? {
        didSet {
            guard backgroundColor?.cgColor.alpha == 0 else { return }

            backgroundColor = oldValue
        }
    }
}
