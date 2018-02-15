/// The result of a network request
///
/// - success: A successful request with resulting `NetworkResponse`
/// - failure: An unsuccessful request with the resulting `Error`
public enum NetworkResult {
    case success(NetworkResponse)
    case failure(Error)
}

public extension NetworkResult {
    /// Is this a failed result?
    var isFailure: Bool {
        switch self {
        case .failure: return true
        default: return false
        }
    }
}

/// An object capable of performing network requests
public protocol Network {
    /// Register `NetworkBehaviour`s that will be used for _all_ requests made from this `Network`
    func register(behaviours: [NetworkBehaviour])

    /// Perform a `NetworkRequest`
    ///
    /// - Parameters:
    ///   - request: The `NetworkRequest` to perform
    ///   - behaviours: `NetworkBehaviour`s that will _only_ be used for this request
    ///   - complete: Closure called upon completion of this request. It provides a `NetworkResult` representing the success or failure.
    ///
    /// - Returns: An object that can be used to cancel the request
    @discardableResult
    func perform(request: NetworkRequest, behaviours: [NetworkBehaviour], complete: @escaping (NetworkResult) -> Void) throws -> Cancellable
}

public extension Network {
    /// Perform a `NetworkRequest`
    ///
    /// - Parameters:
    ///   - request: The `NetworkRequest` to perform
    ///   - complete: Closure called upon completion of this request. It provides a `NetworkResult` representing the success or failure.
    ///
    /// - Returns: An object that can be used to cancel the request
    @discardableResult
    public func perform(request: NetworkRequest, complete: @escaping (NetworkResult) -> Void) throws -> Cancellable {
        return try perform(request: request, behaviours: [], complete: complete)
    }
}
