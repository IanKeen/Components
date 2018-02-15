/*:
 # CellKit

 - Inversion of responsibility for table/collection view cells
 - Allows a scalable solution for an unlimited number of different cell types without any extra code in the VC
 - Keeps all the cell configuration code in one place
 */
import UIKit

class MyCellViewModel1: TableViewCellFactory {
    typealias View = MyCell1

    let value: Int

    init(value: Int) {
        self.value = value
    }

    func selected() {
        print(type(of: self), "Selected", value)
    }
}
class MyCell1: UITableViewCell, Configurable {
    func configure(with config: MyCellViewModel1) {
        textLabel?.text = "\(config.value)"
    }
}
class MyCellViewModel2: TableViewCellFactory {
    typealias View = MyCell2

    let value: String

    init(value: Int) {
        let startingValue = Int(UnicodeScalar("A").value) - 1
        let index = startingValue + value % 26
        self.value = String(Character(UnicodeScalar(index)!))
    }

    func selected() {
        print(type(of: self), "Selected", value)
    }
}
class MyCell2: UITableViewCell, Configurable {
    func configure(with config: MyCellViewModel2) {
        textLabel?.text = config.value
    }
}

class ViewModel {
    let cellModels: [AnyTableViewCellFactory] = (1...20).map { value in
        return value % 2 == 0
            ? MyCellViewModel1(value: value) as AnyTableViewCellFactory
            : MyCellViewModel2(value: value) as AnyTableViewCellFactory
    }
    let factories: [AnyTableViewCellFactory.Type] = [
        MyCellViewModel1.self, MyCellViewModel2.self
    ]
}
class Controller: UITableViewController {
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(factories: viewModel.factories)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellModels[indexPath.row].dequeue(from: tableView, at: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.cellModels[indexPath.row].selected()
    }
}

let controller = Controller()
controller.show()

