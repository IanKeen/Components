@_exported import XCTest
@_exported import PlaygroundSupport

public extension XCTestCase {
    static func run() {
        XCTestSuite(forTestCaseClass: self).run()
    }
}

public protocol CodableEquatable: Codable, Equatable { }

public extension CodableEquatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        let encoder = JSONEncoder()
        return (try! encoder.encode(lhs)) == (try! encoder.encode(rhs))
    }
}

public extension XCTestCase {
    public func ignore(_ expectation: XCTestExpectation) {
        expectation.fulfill()
        waitForExpectations(timeout: 0, handler: nil)
    }
}

extension String: Error { }

extension Optional {
    public func required() throws -> Wrapped {
        switch self {
        case .none: throw "Missing required value"
        case .some(let value): return value
        }
    }
}
