import Foundation

extension NetworkRequest {
    public struct Method: Equatable {
        public let name: String

        public init(name: String) {
            self.name = name
        }

        public static func ==(lhs: Method, rhs: Method) -> Bool {
            return lhs.name == rhs.name
        }

        public static var get: Method { return .init(name: "GET") }
        public static var put: Method { return .init(name: "PUT") }
        public static var patch: Method { return .init(name: "PATCH") }
        public static var post: Method { return .init(name: "POST") }
        public static var delete: Method { return .init(name: "DELETE") }
    }
}

public struct NetworkRequest {
    public let method: Method
    public let url: URL
    public let headers: [String: LosslessStringConvertible]
    public let body: DataRepresentable?

    public init(method: Method = .get, url: URL, headers: [String: LosslessStringConvertible] = [:], body: DataRepresentable? = nil) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }
}

// MARK: - Equatable
extension NetworkRequest: Equatable {
    public static func ==(lhs: NetworkRequest, rhs: NetworkRequest) -> Bool {
        return lhs.method == rhs.method &&
            lhs.url == rhs.url &&
            lhs.headers.string == rhs.headers.string &&
            lhs.body?.string == rhs.body?.string
    }
}

// MARK: - Hashable
extension NetworkRequest: Hashable {
    public var hashValue: Int {
        let headersHash = (headers.string ?? "").hashValue
        let bodyHash = (body?.string ?? "").hashValue

        return self.method.name.hashValue
            ^ url.hashValue
            ^ headersHash
            ^ bodyHash
    }
}

// MARK: - TextOutputStreamable
extension NetworkRequest: TextOutputStreamable {
    public func write<Target: TextOutputStream>(to target: inout Target) {
        target.write("\n"); defer { target.write("\n") }
        
        target.write("curl -X \(method.name)")
        target.write(" \"\(url.absoluteString)\"")
        for (key, value) in headers {
            let sanitizedKey = key.contains(":") ? key : "\(key):"
            target.write(" -H \"\(sanitizedKey) \(value)\"")
        }
        target.write(" -g --verbose")
        if let body = body?.string {
            target.write(" -d '")
            target.write(body)
            target.write("'")
        }
    }
}
