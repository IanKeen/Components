import UIKit

/// A UICollectionViewCell that loads a custom UIView into its .contentView
/// the typed view can be accessed via the .customView property
open class GenericCollectionViewCell<View: UIView>: UICollectionViewCell {
    // MARK: - Properties
    public let customView = View()

    // MARK: - Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Private Functions
    private func configure() {
        contentView.addSubview(customView)

        customView.preservesSuperviewLayoutMargins = false
        customView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            customView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            customView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            ]
        )
    }
}
