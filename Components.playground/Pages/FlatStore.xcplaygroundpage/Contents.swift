public struct StoreKey: Hashable {
    public let type: Any.Type
    public let id: String
    public let key: String

    public init<T>(id: Identifier<T>) {
        self.type = T.self
        self.id = id.rawValue
        self.key = "\(T.self):\(id.rawValue)"
    }
    public init<T: Identifiable>(item: T) {
        self.init(id: item.id)
    }

    public static func ==(lhs: StoreKey, rhs: StoreKey) -> Bool {
        return lhs.key == rhs.key
    }

    public var hashValue: Int { return key.hashValue }
}

private extension Identifiable {
    var storeKey: StoreKey { return StoreKey(item: self) }
}

public class FlatStore {
    // MARK: - Private Properties
    private var items: [StoreKey: Any] = [:]

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func upsert<T: Identifiable>(_ item: T) {
        items[item.storeKey] = item
    }
    public func remove<T: Identifiable>(_ item: T) {
        items.removeValue(forKey: item.storeKey)
    }
    public func all<T: Identifiable>(_: T.Type = T.self) -> AnySequence<T> {
        var copy = items

        return AnySequence<T> { () -> AnyIterator<T> in
            var index = copy.startIndex

            return AnyIterator<T> {
                while index < copy.endIndex {
                    defer { index = copy.index(after: index) }

                    if let item = copy[index].value as? T {
                        return item
                    }
                }
                return nil
            }
        }
    }
}

private struct User1: Identifiable {
    let id: Identifier<User1>
    let name: String
}

private struct User2: Identifiable {
    let id: Identifier<User2>
    let name: String
}

private let a1 = User1(id: "A1", name: "Ian")
private let a2 = User1(id: "A2", name: "Bob")
private let b1 = User2(id: "B1", name: "Joe")
private let a3 = User1(id: "A3", name: "Frank")
private let b2 = User2(id: "B2", name: "Joe2a")
private let b3 = User2(id: "B3", name: "Jaoe3")

let store = FlatStore()
store.upsert(a1)
store.upsert(b1)
store.upsert(a2)
store.upsert(a3)
store.upsert(b2)
store.upsert(b3)

private let result = store.all(User2.self).lazy.prefix(2)
for u in result {
    print(u)
}
