import Foundation

public func value<Result: Decodable, Key: CodingKey>(_ case: Result, for key: Key) throws -> Decode<Result, Key> {
    return { container in
        guard let _ = try container.decodeIfPresent(String.self, forKey: key) else { return nil }
        return `case`
    }
}
public func value<Result: Decodable, Key: CodingKey, T: Decodable>(_ function: @escaping (T) -> Result, for key: Key) throws -> Decode<Result, Key> {
    return { container in
        guard let value = try container.decodeIfPresent(T.self, forKey: key) else { return nil }
        return function(value)
    }
}
