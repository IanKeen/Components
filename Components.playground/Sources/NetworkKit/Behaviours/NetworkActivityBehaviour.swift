import Foundation

public protocol NetworkActivityProvider: class {
    var isNetworkActivityIndicatorVisible: Bool { get set }
}

public class NetworkActivityBehaviour: NetworkRequestWillBeginBehaviour, NetworkRequestCompleteBehaviour {
    static private(set) var requests: Int = 0

    static private let queue = DispatchQueue(label: "requestCount.queue")
    private func update(_ value: Int) {
        NetworkActivityBehaviour.queue.sync {
            NetworkActivityBehaviour.requests += value
        }
    }

    private let networkActivityProvider: NetworkActivityProvider

    public init(networkActivityProvider: NetworkActivityProvider) {
        self.networkActivityProvider = networkActivityProvider
    }

    public func requestWillBegin(network: Network, request: NetworkRequest, next: @escaping NetworkRequestWillBeginBehaviour.RequestWillBeginHandler) {
        networkActivityProvider.isNetworkActivityIndicatorVisible = true
        update(1)

        next(request)
    }

    public func requestComplete(network: Network, request: NetworkRequest, result: NetworkResult) {
        update(-1)
        guard NetworkActivityBehaviour.requests == 0 else { return }

        networkActivityProvider.isNetworkActivityIndicatorVisible = false
    }
}
