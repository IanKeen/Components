import Foundation

public extension Array where Element == NetworkRequestWillBeginBehaviour {
    /// Executes the `requestWillBegin` function on this array of `NetworkRequestWillBeginBehaviour`s
    ///
    /// - Parameters:
    ///   - network: The `Network` performing the request
    ///   - request: The `NetworkRequest` being performed
    ///   - complete: Closure called once all `NetworkRequestWillBeginBehaviour`s have completed their `requestWillBegin`
    public func willBegin(network: Network, request: NetworkRequest, complete: @escaping NetworkRequestWillBeginBehaviour.RequestWillBeginHandler) {
        guard let next = first else { return complete(request) }

        next.requestWillBegin(network: network, request: request) { newRequest in
            let remainder = Array(self.dropFirst())
            remainder.willBegin(network: network, request: newRequest, complete: complete)
        }
    }
}

public extension Array where Element == NetworkRequestDidBeginBehaviour {
    /// Executes the `requestDidBegin` function on this array of `NetworkRequestDidBeginBehaviour`s
    ///
    /// - Parameters:
    ///   - network: The `Network` performing the request
    ///   - request: The `NetworkRequest` being performed
    ///   - cancellable: A `Cancellable` object representing the operation being performed
    public func didBegin(network: Network, request: NetworkRequest, cancellable: Cancellable) {
        forEach { $0.requestDidBegin(network: network, request: request, cancellable: cancellable) }
    }
}

public extension Array where Element == NetworkRequestReceivedBehaviour {
    /// Executes the `requestReceived` function on this array of `NetworkRequestReceivedBehaviour`s
    ///
    /// - Parameters:
    ///   - network: The `Network` performing the request
    ///   - request: The `NetworkRequest` being performed
    ///   - currentResult: The initial `NetworkResult` to send through the delegates
    ///   - complete: Closure called once all `NetworkRequestReceivedBehaviour`s have completed their `requestReceived`
    public func received(network: Network, request: NetworkRequest, currentResult: NetworkResult, complete: @escaping NetworkRequestReceivedBehaviour.RequestReceivedHandler) {
        guard let next = first else { return complete(currentResult) }

        next.requestReceived(network: network, request: request, currentResult: currentResult) { result in
            let remainder = Array(self.dropFirst())
            remainder.received(network: network, request: request, currentResult: result, complete: complete)
        }
    }
}

public extension Array where Element == NetworkRequestCompleteBehaviour {
    /// Executes the `requestComplete` function on this array of `NetworkRequestCompleteBehaviour`s
    ///
    /// - Parameters:
    ///   - network: The `Network` performing the request
    ///   - request: The `NetworkRequest` being performed
    ///   - result: The `NetworkResult` to send through the delegates
    public func completed(network: Network, request: NetworkRequest, result: NetworkResult) {
        forEach { $0.requestComplete(network: network, request: request, result: result) }
    }
}

// Convenience extensions to simplify `Network` implementation callsites
public extension Array where Element == NetworkBehaviour {
    public func willBegin(network: Network, request: NetworkRequest, complete: @escaping NetworkRequestWillBeginBehaviour.RequestWillBeginHandler) {
        let items = flatMap { $0 as? NetworkRequestWillBeginBehaviour }
        items.willBegin(network: network, request: request, complete: complete)
    }
    public func didBegin(network: Network, request: NetworkRequest, cancellable: Cancellable) {
        let items = flatMap { $0 as? NetworkRequestDidBeginBehaviour }
        items.didBegin(network: network, request: request, cancellable: cancellable)
    }
    public func received(network: Network, request: NetworkRequest, currentResult: NetworkResult, complete: @escaping NetworkRequestReceivedBehaviour.RequestReceivedHandler) {
        let items = flatMap { $0 as? NetworkRequestReceivedBehaviour }
        items.received(network: network, request: request, currentResult: currentResult, complete: complete)
    }
    public func completed(network: Network, request: NetworkRequest, result: NetworkResult) {
        let items = flatMap { $0 as? NetworkRequestCompleteBehaviour }
        items.completed(network: network, request: request, result: result)
    }
}
