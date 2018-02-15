import UIKit

public protocol TableViewCellFactory: AnyTableViewCellFactory {
    associatedtype View: UITableViewCell
}

public extension TableViewCellFactory {
    public static func register(with tableView: UITableView) {
        tableView.register(View.self, forCellReuseIdentifier: View.reuseIdentifier)
    }
    public func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: View.reuseIdentifier, for: indexPath)
    }
}

public protocol CollectionViewCellFactory: AnyCollectionViewCellFactory {
    associatedtype View: UICollectionViewCell
}

public extension CollectionViewCellFactory {
    public static func register(with collectionView: UICollectionView) {
        collectionView.register(View.self, forCellWithReuseIdentifier: View.reuseIdentifier)
    }
    public func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: View.reuseIdentifier, for: indexPath)
    }
}

