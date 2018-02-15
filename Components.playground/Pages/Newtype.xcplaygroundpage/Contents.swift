/*:
 # Newtype
 Type introduced to me by Tim Vermeulen

 - Generic wrapper type - concept from Haskell
 - Allows encapsulating a scalar value and provide default implementations for a range of common protocols
 - Allows a means to 'subclass/typealias' scalar types to enforce type safety but not pollute the inner types API

 To quote Tim:
 ```
 it’s like a type-safe `typealias`. so you could imagine doing `typealias Miles = Double` and have a function that accepts `Miles`, but the problem with that is that you can still pass it, say, a `TimeInterval` (since it’s also a type alias of `Double`) so it’s basically a wrapper around a type that holds a value of that type and nothing else, and it adds methods that aren’t added on the original type (e.g. you don’t want `TimeInterval` to have a `toKilometers()` method)
 ```
 */

private struct Foo: Newtype, Equatable, Comparable, Hashable, Codable {
    let rawValue: Int
}

private struct CodableFoo: Codable {
    let foo: Foo
}

class NewTypeTests: XCTestCase {
    func test_Equatable() {
        XCTAssertEqual(Foo(rawValue: 0), Foo(rawValue: 0))
        XCTAssertNotEqual(Foo(rawValue: 0), Foo(rawValue: 1))
    }
    func test_Comparable() {
        XCTAssertTrue(Foo(rawValue: 0) < Foo(rawValue: 1))
        XCTAssertTrue(Foo(rawValue: 1) > Foo(rawValue: 0))
        XCTAssertTrue(Foo(rawValue: 0) == Foo(rawValue: 0))
    }
    func test_Hashable() {
        XCTAssertEqual(Foo(rawValue: 0).hashValue, Foo(rawValue: 0).hashValue)
        XCTAssertEqual(Set<Foo>([Foo(rawValue: 0), Foo(rawValue: 0)]).count, 1)
    }
    func test_Encodable() throws {
        let value = 42
        let encoder = JSONEncoder()

        let input = CodableFoo(foo: .init(rawValue: value))
        let output = "{\"foo\":42}".data(using: .utf8)!

        let result = try encoder.encode(input)
        XCTAssertEqual(result, output)
    }
    func test_Decodable() throws {
        let value = 42
        let decoder = JSONDecoder()

        let input = "{\"foo\":42}".data(using: .utf8)!
        let output = CodableFoo(foo: .init(rawValue: value))

        let result = try decoder.decode(CodableFoo.self, from: input)
        XCTAssertEqual(result.foo, output.foo)
    }
}

NewTypeTests.run()

