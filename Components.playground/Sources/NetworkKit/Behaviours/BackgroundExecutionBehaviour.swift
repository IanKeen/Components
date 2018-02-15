public typealias BackgroundTaskIdentifier = Int

public protocol BackgroundTaskProvider {
    func beginBackgroundTask(withName taskName: String?, expirationHandler handler: (() -> Swift.Void)?) -> BackgroundTaskIdentifier
    func endBackgroundTask(_ identifier: BackgroundTaskIdentifier)
}

public class BackgroundExecutionBehaviour: NetworkRequestDidBeginBehaviour, NetworkRequestCompleteBehaviour {
    private var backgroundTasks: [NetworkRequest: BackgroundTaskIdentifier] = [:]
    private let backgroundTaskProvider: BackgroundTaskProvider

    public init(backgroundTaskProvider: BackgroundTaskProvider) {
        self.backgroundTaskProvider = backgroundTaskProvider
    }

    public func requestDidBegin(network: Network, request: NetworkRequest, cancellable: Cancellable) {
        let token = backgroundTaskProvider.beginBackgroundTask(withName: request.url.absoluteString) {
            cancellable.cancel()
        }
        backgroundTasks[request] = token
    }
    public func requestComplete(network: Network, request: NetworkRequest, result: NetworkResult) {
        guard let token = backgroundTasks[request] else { return }

        backgroundTaskProvider.endBackgroundTask(token)
        backgroundTasks[request] = nil
    }
}
