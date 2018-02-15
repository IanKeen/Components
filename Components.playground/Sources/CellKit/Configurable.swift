import UIKit

public protocol Configurable {
    associatedtype Configuration

    func configure(with config: Configuration)
}

public extension TableViewCellFactory where View: Configurable, View.Configuration == Self {
    public func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: View.reuseIdentifier, for: indexPath) as? View
            else { fatalError("Unable to dequeue expected type '\(View.self)'") }

        cell.configure(with: self)

        return cell
    }
}

public extension CollectionViewCellFactory where View: Configurable, View.Configuration == Self {
    func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: View.reuseIdentifier, for: indexPath) as? View
            else { fatalError("Unable to dequeue expected type '\(View.self)'") }

        cell.configure(with: self)

        return cell
    }
}
