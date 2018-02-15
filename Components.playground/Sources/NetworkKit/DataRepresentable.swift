import Foundation

/// An object that can be represented as `Data`
public protocol DataRepresentable {
    /// Attempt to convert the receiver into `Data`
    func data() throws -> Data
}

public extension DataRepresentable {
    /// Attempt to obtain a `String` from the `Data` representation of the receiver
    public var string: String? {
        return (try? self.data()).flatMap { String(data: $0, encoding: .utf8) }
    }
}

public extension DataRepresentable where Self: Encodable {
    public func data() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Data: DataRepresentable {
    public func data() throws -> Data {
        return self
    }
}

extension Dictionary: DataRepresentable {
    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Array: DataRepresentable {
    public func data() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }
}
