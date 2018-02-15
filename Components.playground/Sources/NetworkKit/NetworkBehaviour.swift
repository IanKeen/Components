import Foundation

/// An object that can participate in the network request/response process
public protocol NetworkBehaviour { }

public protocol NetworkRequestWillBeginBehaviour: NetworkBehaviour {
    typealias RequestWillBeginHandler = (NetworkRequest) -> Void

    /// Called before a request is started. This provides an opportunity
    /// to alter the `NetworkRequest` before it begins.
    ///
    /// - Note: `next` _must_ be called otherwise the code will stall.
    ///
    /// - Parameters:
    ///   - request: The current `NetworkRequest` that will be executed.
    ///   - next: Called when the work here is complete.
    func requestWillBegin(
        network: Network,
        request: NetworkRequest,
        next: @escaping RequestWillBeginHandler
    )
}

public protocol NetworkRequestDidBeginBehaviour: NetworkBehaviour {
    /// Called after a request has started.
    ///
    /// - Parameters:
    ///   - request: The `NetworkRequest` that was started.
    ///   - cancellable: A `Cancellable` representing the underlying operation.
    func requestDidBegin(
        network: Network,
        request: NetworkRequest,
        cancellable: Cancellable
    )
}

public protocol NetworkRequestReceivedBehaviour: NetworkBehaviour {
    typealias RequestReceivedHandler = (NetworkResult) -> Void

    /// Called once a response has been received as a result of the `NetworkRequest`.
    /// This provides an opportunity to alter the `NetworkResult` before it completes.
    ///
    /// - Note: `next` _must_ be called otherwise the code will stall.
    ///
    /// - Parameters:
    ///   - request: The `NetworkRequest` that resulted in this response.
    ///   - currentResult: A `NetworkResult` representing the current success or failure of this request.
    ///   - next: Called when the work here is complete.
    func requestReceived(
        network: Network,
        request: NetworkRequest,
        currentResult: NetworkResult,
        next: @escaping RequestReceivedHandler
    )
}

public protocol NetworkRequestCompleteBehaviour: NetworkBehaviour {
    /// Called once a request has completed and all `NetworkOperationDelegate`s 
    /// have had an opportunity to process the response.
    ///
    /// - Parameters:
    ///   - request: The `NetworkRequest` that was performed.
    ///   - result: The `NetworkResult` that was received.
    func requestComplete(
        network: Network,
        request: NetworkRequest,
        result: NetworkResult
    )
}
