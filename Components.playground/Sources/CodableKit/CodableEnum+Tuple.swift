import Foundation

public struct None: Codable { }

public func value<Result: Decodable, Key: CodingKey, A: Codable, B: Codable>(_ function: @escaping (A, B) -> Result, for key: Key) throws -> Decode<Result, Key> {
    return { container in
        guard
            let value = try container.decodeIfPresent(Coded<A, B, None>.self, forKey: key),
            let a = value.a, let b = value.b
            else { return nil }

        return function(a, b)
    }
}
public func value<Result: Decodable, Key: CodingKey, A: Codable, B: Codable, C: Codable>(_ function: @escaping (A, B, C) -> Result, for key: Key) throws -> Decode<Result, Key> {
    return { container in
        guard
            let value = try container.decodeIfPresent(Coded<A, B, C>.self, forKey: key),
            let a = value.a, let b = value.b, let c = value.c
            else { return nil }

        return function(a, b, c)
    }
}

public struct Coded<A: Codable, B: Codable, C: Codable>: Codable {
    let a: A?
    let b: B?
    let c: C?

    private enum CodingKeys: CodingKey {
        case a, b, c
    }

    public init(_ a: A? = nil, _ b: B? = nil, _ c: C? = nil) {
        self.a = a
        self.b = b
        self.c = c
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self = .init(
            try container.decodeIfPresent(A.self, forKey: .a),
            try container.decodeIfPresent(B.self, forKey: .b),
            try container.decodeIfPresent(C.self, forKey: .c)
        )
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(a, forKey: .a)
        try container.encodeIfPresent(b, forKey: .b)
        try container.encodeIfPresent(c, forKey: .c)
    }
}
