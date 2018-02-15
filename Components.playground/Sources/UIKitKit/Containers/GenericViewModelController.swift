import UIKit

/// A UIViewController that loads a custom UIView as its .view
/// the typed view can be accessed via the .customView property
///
/// It also enforces a specific view model be provided upon creation
/// which can be accessed via the .viewModel property
open class GenericViewModelController<ViewType: UIView, ViewModelType>: GenericViewController<ViewType> {
    /// Provides typed access to the view controllers view model
    public let viewModel: ViewModelType

    // MARK - Lifecycle
    required public init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    public init() {
        fatalError("Must be initialised using init(viewModel:)")
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Must be initialised using init(viewModel:)")
    }
}
