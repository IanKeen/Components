import Foundation

public extension KeyedDecodingContainer {
    public func decode<T: Decodable, Inner: CodingKey>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key, innerKey: Inner) throws -> [T] {
        var array = try nestedUnkeyedContainer(forKey: key)

        var items: [T] = []
        while !array.isAtEnd {
            let container = try array.nestedContainer(keyedBy: Inner.self)
            let item = try container.decode(T.self, forKey: innerKey)
            items.append(item)
        }
        return items
    }
    public func decodeIfPresent<T: Decodable, Inner: CodingKey>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key, innerKey: Inner) throws -> [T]? {
        guard contains(key) else { return nil }

        return try decode(type, forKey: key, innerKey: innerKey)
    }
}

public extension KeyedEncodingContainer {
    public mutating func encode<T: Encodable, Inner: CodingKey>(_ value: [T], forKey key: KeyedEncodingContainer.Key, innerKey: Inner) throws {
        var array = nestedUnkeyedContainer(forKey: key)
        for item in value {
            var container = array.nestedContainer(keyedBy: Inner.self)
            try container.encode(item, forKey: innerKey)
        }
    }
    public mutating func encodeIfPresent<T: Encodable, Inner: CodingKey>(_ value: [T]?, forKey key: KeyedEncodingContainer.Key, innerKey: Inner) throws {
        guard let value = value, !value.isEmpty else { return }

        try encode(value, forKey: key, innerKey: innerKey)
    }
}
