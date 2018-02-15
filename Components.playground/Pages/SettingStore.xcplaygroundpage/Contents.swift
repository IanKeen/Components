/*:
 # SettingStore

 - Provides a typesafe means of storing and vending values.
 - `Setting`s are predefined.
 - `Setting`s required defaults so values will never be `nil`.
 - Stores any `Codable` value.
 */

private struct Model: CodableEquatable {
    let name: String
    let age: Int
}

private extension Setting {
    static var value: Setting<Int> { return .init(key: "value", default: 42) }
    static var model: Setting<Model> { return .init(key: "model", default: .init(name: "Ian", age: 35)) }
}

class SettingStoreTests: XCTestCase {
    func runTests(on store: SettingStore, file: StaticString = #file, line: UInt = #line) {
        var count = 0
        store.onUpdate = { _ in count += 1}

        //should deliver defaults initially
        XCTAssertEqual(store.value(for: .value), 42)
        XCTAssertEqual(store.value(for: .model), .init(name: "Ian", age: 35))

        //updating the values...
        store.update(.value, to: 0)
        store.update(.model, to: .init(name: "Joe", age: 42))

        //should deliver updated values
        XCTAssertEqual(store.value(for: .value), 0, file: file, line: line)
        XCTAssertEqual(store.value(for: .model), .init(name: "Joe", age: 42), file: file, line: line)

        //should update count for each edit
        XCTAssertEqual(count, 2)
    }

    func testMemoryStore() {
        runTests(on: MemorySettingStore())
    }
}

SettingStoreTests.run()
