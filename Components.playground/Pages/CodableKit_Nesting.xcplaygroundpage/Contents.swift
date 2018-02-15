private struct Parent: Codable {
    let items: [Item]
}
private struct Item: Codable {
    let name: String
}


extension Parent {
    private enum CodingKeys: String, CodingKey {
        case attachments
    }
    private enum AttachmentKeys: String, CodingKey {
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode(Item.self, forKey: .attachments, innerKey: AttachmentKeys.content)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .attachments, innerKey: AttachmentKeys.content)
    }
}


class CodableNestingTests: XCTestCase {
    let json = """
{
    "attachments": [
        {
            "content": {
                "name": "foo"
            }
        },
        {
            "content": {
                "name": "bar"
            }
        }
    ]
}
""".data(using: .utf8)!

    func testNesting() throws {
        // Decoding
        let object = try JSONDecoder().decode(Parent.self, from: json)
        XCTAssertEqual(object.items.count, 2)
        XCTAssertEqual(object.items[0].name, "foo")
        XCTAssertEqual(object.items[1].name, "bar")

        // Encoding
        let parent = Parent(items: [
            Item(name: "foo"),
            Item(name: "bar")
            ]
        )
        let string = try String(data: JSONEncoder().encode(parent), encoding: .utf8)!
        XCTAssertEqual(string, "{\"attachments\":[{\"content\":{\"name\":\"foo\"}},{\"content\":{\"name\":\"bar\"}}]}")
    }
}

CodableNestingTests.run()
