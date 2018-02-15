/*:
 # KeyValueStore

 - Provides a typesafe means of storing and vending values.
 - Keys are `String`s and therefore dynamic.
 - Values can be `nil`.
 - Stores any `Codable` value.
 */

private struct Model: CodableEquatable {
    let name: String
    let age: Int
}

class KeyValueStorageTests: XCTestCase {
    func runTests(on store: KeyValueStore, file: StaticString = #file, line: UInt = #line) {
        var counts: [String: Int] = [:]
        store.onUpdate = { _, key in counts[key, default: 0] += 1 }

        //should deliver nil initially
        XCTAssertNil(store.value(for: "value") as Int?)
        XCTAssertNil(store.value(for: "model") as Model?)

        //updating the values...
        store.update("value", to: 0)
        store.update("model", to: Model(name: "Joe", age: 42))

        //should deliver updated values
        XCTAssertEqual(store.value(for: "value"), 0, file: file, line: line)
        XCTAssertEqual(store.value(for: "model"), Model(name: "Joe", age: 42), file: file, line: line)

        //should update count for each edit
        XCTAssertEqual(counts, ["value": 1, "model": 1])
    }

    func testMemoryStore() {
        runTests(on: MemoryKeyValueStore())
    }
}

KeyValueStorageTests.run()
