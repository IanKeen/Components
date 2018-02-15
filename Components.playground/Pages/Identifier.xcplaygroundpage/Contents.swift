import XCTest

class IdentifierTests: XCTestCase {
    func test() {
        let a: Identifier<Void> = "foo"
        let b: Identifier<Void> = "bar"

        XCTAssertTrue(a != b)
    }
}

IdentifierTests.run()

private struct User {
    let id: Identifier<User>
}

private let user = User(id: "foo")
user.id.rawValue
