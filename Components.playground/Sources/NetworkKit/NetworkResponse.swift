import Foundation

public struct NetworkResponse: TextOutputStreamable {
    public let response: HTTPURLResponse
    public let data: Data?

    public init(response: HTTPURLResponse, data: Data?) {
        self.response = response
        self.data = data
    }

    public func write<Target>(to target: inout Target) where Target : TextOutputStream {
        target.write("Response: \(response)")
        if let data = data {
            target.write("\nData: \(data.string ?? "<empty>")")
        }
    }
}

extension NetworkResponse: Equatable {
    public static func ==(lhs: NetworkResponse, rhs: NetworkResponse) -> Bool {
        guard lhs.response == rhs.response else { return false }

        switch (lhs.data, rhs.data) {
        case (nil, nil): return true
        case (let left?, let right?): return left == right
        default: return false
        }
    }
}

public extension NetworkResponse {
    /// Create a new `NetworkResponse` with updated `Data`
    public func updating(data: Data?) -> NetworkResponse {
        return NetworkResponse(
            response: response,
            data: data
        )
    }
}

// MARK: - Conversions
public extension NetworkResponse {
    /// Attempt to convert the `NetworkResponse`s `Data` into a JSON dictionary
    public var jsonDictionary: [String: Any]? {
        guard let data = data else { return nil }

        do { return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] }
        catch { return nil }
    }

    /// Attempt to convert the `NetworkResponse`s `Data` into an array JSON dictionaries
    public var jsonDictionaryArray: [[String: Any]]? {
        guard let data = data else { return nil }

        do { return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] }
        catch { return nil }
    }

    /// Attempt to convert the `NetworkResponse`s `Data` into a non-empty `String`
    public var string: String? {
        guard
            let data = data,
            let value = String(data: data, encoding: .utf8),
            !value.isEmpty
            else { return nil }

        return value
    }
}
