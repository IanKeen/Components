import UIKit

public class StylesheetManager {
    // MARK: - Private Properties
    private let updater: Updater<Stylesheet>

    // MARK: - Public Properties
    public let onStylesheetChange: Output<Stylesheet>

    // MARK: - Lifecycle
    public init(stylesheet: Stylesheet) {
        (self.onStylesheetChange, self.updater) = Output<Stylesheet>.create(startingWith: stylesheet, equality: notEquatable)
    }

    // MARK: - Public Functions
    /// Update the current `Stylesheet` being used.
    public func changeStylesheet(to stylesheet: Stylesheet) {
        updater(stylesheet)
    }
}

public extension UIViewController {
    /// Keep this `UIViewController`s style in sync with the `StylesheetManager`
    public func bindStyle(from manager: StylesheetManager, animated: Bool = true) -> Subscription {
        return manager.onStylesheetChange.subscribe { [weak self] sheet in
            guard let this = self else { return }
            sheet.apply(to: this.view, animated: animated)
        }
    }
}

