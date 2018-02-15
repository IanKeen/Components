public enum APIError: Error {
    case invalidResponse
}

/// An object used to perform a `NetworkRequest` and convert the `NetworkResponse` into a specific type
public protocol APIRequest {
    associatedtype Response

    /// Whether this request should be signed with the authentication header, default: true
    var authenticationRequired: Bool { get }

    /// The `NetworkRequest` to perform
    func networkRequest(baseUrl: URL) -> NetworkRequest

    /// Handles the returned `NetworkResponse` converting in into a `Response`
    func handle(response: NetworkResponse) throws -> Response
}

public extension APIRequest {
    var authenticationRequired: Bool { return true }
}

public extension APIRequest where Response: Codable {
    public func handle(response: NetworkResponse) throws -> Response {
        guard let data = response.data else { throw APIError.invalidResponse }

        return try JSONDecoder().decode(Response.self, from: data)
    }
}

public enum APIResult<T: APIRequest> {
    case success(T.Response)
    case failure(Error)
}

public class API {
    /// The configuration used
    public struct Configuration {
        public typealias AuthenticatioHeaders = (() -> [String: LosslessStringConvertible])

        /// The base `URL` to use for all requests
        public let baseUrl: URL

        /// Headers to be added to all requests
        public let commonHeaders: [String: LosslessStringConvertible]

        /// Authentication headers to be added to all requests whose `authenticationRequired` are `true`
        public let authenticationHeaders: AuthenticatioHeaders

        // MARK: - Lifecycle
        public init(baseUrl: URL, commonHeaders: [String: LosslessStringConvertible], authenticationHeaders: @escaping AuthenticatioHeaders) {
            self.baseUrl = baseUrl
            self.commonHeaders = commonHeaders
            self.authenticationHeaders = authenticationHeaders
        }
    }

    // MARK: - Private Properties
    private let network: Network
    private let configuration: Configuration

    // MARK: - Lifecycle
    /// Create a new API instance
    ///
    /// - Parameter network: The `Network` that handles the network communication
    /// - Parameter configuration: The `Configuration` for this `API`
    public init(network: Network, configuration: Configuration) {
        self.network = network
        self.configuration = configuration
    }

    // MARK: - Public Functions
    /// Perform an api request
    ///
    /// - Parameters:
    ///   - request: The `APIRequest` to perform
    ///   - complete: The closure called with the success or failure of the request
    /// - Returns: An object that can be used to cancel the request
    @discardableResult
    public func perform<T>(request: T, complete: @escaping (APIResult<T>) -> Void) throws -> Cancellable {
        let networkRequest = request
            .networkRequest(baseUrl: configuration.baseUrl)
            .adding(headers: configuration.commonHeaders)
            .signed(with: configuration, required: request.authenticationRequired)

        return try network.perform(request: networkRequest) { result in
            do {
                switch result {
                case .success(let response):
                    try complete(.success(request.handle(response: response)))
                case .failure(let error):
                    throw error
                }

            } catch let error {
                complete(.failure(error))
            }
        }
    }
}

private extension Dictionary {
    func appending(_ other: [Key: Value]) -> [Key: Value] {
        var result = self
        for (key, value) in other {
            result[key] = value
        }
        return result
    }
}

private extension NetworkRequest {
    func adding(headers other: [String: LosslessStringConvertible]) -> NetworkRequest {
        return NetworkRequest(
            method: method,
            url: url,
            headers: headers.appending(other),
            body: body
        )
    }
    func signed(with configuration: API.Configuration, required: Bool) -> NetworkRequest {
        guard required else { return self }

        return NetworkRequest(
            method: method,
            url: url,
            headers: headers.appending(configuration.authenticationHeaders()),
            body: body
        )
    }
}

