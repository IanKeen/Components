import UIKit

public protocol AnyTableViewCellFactory {
    static func register(with tableView: UITableView)
    func dequeue(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func selected()
}

extension AnyTableViewCellFactory {
    public func selected() { }
}

public extension UITableView {
    public func register(factories: [AnyTableViewCellFactory.Type]) {
        factories.forEach { $0.register(with: self) }
    }
}

public protocol AnyCollectionViewCellFactory {
    static func register(with collectionView: UICollectionView)
    func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}

public extension UICollectionView {
    public func register(cells: [AnyCollectionViewCellFactory.Type]) {
        cells.forEach { $0.register(with: self) }
    }
}
