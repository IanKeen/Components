import UIKit

/// A UITableViewCell that loads a custom UIView into its .contentView
/// the typed view can be accessed via the .customView property
open class GenericTableViewCell<View: UIView>: UITableViewCell {
    // MARK: - Properties
    public let customView = View()

    // MARK: - Lifecycle
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
