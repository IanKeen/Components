import Foundation

public protocol Newtype { // Cloak.
    associatedtype RawValue

    var rawValue: RawValue { get }

    init(rawValue: RawValue)
}

extension Newtype where Self: Equatable, RawValue: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Newtype where Self: Comparable, RawValue: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Newtype where Self: Hashable, RawValue: Hashable {
    public var hashValue: Int { return rawValue.hashValue }
}

extension Newtype where Self: Encodable, RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension Newtype where Self: Decodable, RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = .init(rawValue: try container.decode(RawValue.self))
    }
}
