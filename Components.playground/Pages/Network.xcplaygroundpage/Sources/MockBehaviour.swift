public enum BehaviourEvent: String, Hashable {
    case willBegin, didBegin, received, complete
}

public class MockBehaviour: NetworkRequestWillBeginBehaviour, NetworkRequestDidBeginBehaviour, NetworkRequestReceivedBehaviour, NetworkRequestCompleteBehaviour {
    private(set) public var events: [BehaviourEvent: Int] = [
        .willBegin: 0, .didBegin: 0, .received: 0, .complete: 0
    ]

    public typealias WillBegin = (Network, NetworkRequest, @escaping NetworkRequestWillBeginBehaviour.RequestWillBeginHandler) -> Void
    private let willBegin: WillBegin?

    public typealias DidBegin = (Network, NetworkRequest, Cancellable) -> Void
    private let didBegin: DidBegin?

    public typealias Received = (Network, NetworkRequest, NetworkResult, @escaping NetworkRequestReceivedBehaviour.RequestReceivedHandler) -> Void
    private let received: Received?

    public typealias Complete = (Network, NetworkRequest, NetworkResult) -> Void
    private let complete: Complete?

    public init(willBegin: WillBegin? = nil, didBegin: DidBegin? = nil, received: Received? = nil, complete: Complete? = nil) {
        self.willBegin = willBegin
        self.didBegin = didBegin
        self.received = received
        self.complete = complete
    }

    public func requestWillBegin(network: Network, request: NetworkRequest, next: @escaping NetworkRequestWillBeginBehaviour.RequestWillBeginHandler) {
        events[.willBegin]! += 1
        if let willBegin = willBegin {
            willBegin(network, request, next)
        } else {
            next(request)
        }
    }
    public func requestDidBegin(network: Network, request: NetworkRequest, cancellable: Cancellable) {
        events[.didBegin]! += 1
        didBegin?(network, request, cancellable)
    }
    public func requestReceived(network: Network, request: NetworkRequest, currentResult: NetworkResult, next: @escaping NetworkRequestReceivedBehaviour.RequestReceivedHandler) {
        events[.received]! += 1
        if let received = received {
            received(network, request, currentResult, next)
        } else {
            next(currentResult)
        }
    }
    public func requestComplete(network: Network, request: NetworkRequest, result: NetworkResult) {
        events[.complete]! += 1
        complete?(network, request, result)
    }
}
