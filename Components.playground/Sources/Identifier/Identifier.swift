import Foundation

public struct Identifier<T>: Newtype, Hashable, Codable {
    public let rawValue: String

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
extension Identifier {
    public init(_ value: String = NSUUID().uuidString) {
        self.rawValue = value
    }
}
extension Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public protocol Identifiable {
    var id: Identifier<Self> { get }
}
