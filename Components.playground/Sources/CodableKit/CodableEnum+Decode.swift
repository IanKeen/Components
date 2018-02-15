import Foundation

public typealias Decode<Result: Decodable, Key: CodingKey> = (KeyedDecodingContainer<Key>) throws -> Result?

public func decode<Result: Decodable, Key>(using container: KeyedDecodingContainer<Key>, cases: [Decode<Result, Key>]) throws -> Result {
    guard let result = try cases.lazy.flatMap({ try $0(container) }).first
        else { throw DecodingError.valueNotFound(Result.self, .init(codingPath: container.codingPath, debugDescription: "")) }

    return result
}
