import Foundation

private enum Item: CodableEquatable {
    case foo
    case bar(String)
    case qux(Int, Bool)

    private enum CodingKeys: String, CodingKey {
        case foo, bar, qux
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .foo: try container.encode(CodingKeys.foo.stringValue, forKey: .foo)
        case .bar(let value): try container.encode(value, forKey: .bar)
        case .qux(let a, let b): try container.encode(Coded<Int, Bool, None>(a, b, nil), forKey: .qux)
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = try decode(
            using: container,
            cases: [
                value(Item.foo, for: .foo),
                value(Item.bar, for: .bar),
                value(Item.qux, for: .qux),
            ]
        )
    }
}

private extension Encodable {
    func jsonString() throws -> String? {
        let data = try JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8)
    }
}

class CodableEnumTests: XCTestCase {
    static let foo = "{\"foo\":\"foo\"}"
    static let bar = "{\"bar\":\"bar value\"}"
    static let qux = "{\"qux\":{\"a\":42,\"b\":false}}"

    func test_Encoding() throws {
        let a = Item.foo
        let b = Item.bar("bar value")
        let c = Item.qux(42, false)

        try XCTAssertEqual(a.jsonString().required(), CodableEnumTests.foo)
        try XCTAssertEqual(b.jsonString().required(), CodableEnumTests.bar)
        try XCTAssertEqual(c.jsonString().required(), CodableEnumTests.qux)
    }
    func test_Decoding() throws {
        let a = try CodableEnumTests.foo.data(using: .utf8).required()
        let b = try CodableEnumTests.bar.data(using: .utf8).required()
        let c = try CodableEnumTests.qux.data(using: .utf8).required()

        let decoder = JSONDecoder()

        try XCTAssertEqual(decoder.decode(Item.self, from: a), Item.foo)
        try XCTAssertEqual(decoder.decode(Item.self, from: b), Item.bar("bar value"))
        try XCTAssertEqual(decoder.decode(Item.self, from: c), Item.qux(42, false))
    }
}

CodableEnumTests.run()
