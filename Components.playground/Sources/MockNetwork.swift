import Foundation

extension DispatchWorkItem: Cancellable { }

public class MockNetwork: Network {
    // MARK: - Private Properties
    private var behaviours: [NetworkBehaviour] = []
    private let code: Int
    private let data: Data?

    // MARK: - Lifecycle
    public init(code: Int, data: Data?) {
        self.code = code
        self.data = data
    }

    // MARK: - Public
    public func register(behaviours: [NetworkBehaviour]) {
        self.behaviours = behaviours
    }
    public func perform(request: NetworkRequest, behaviours: [NetworkBehaviour], complete: @escaping (NetworkResult) -> Void) throws -> Cancellable {
        let combinedBehaviours = behaviours + self.behaviours
        let operation = NetworkOperation()

        combinedBehaviours.willBegin(network: self, request: request) { request in
            let task = DispatchWorkItem {
                let networkResponse = NetworkResponse(
                    response: HTTPURLResponse(url: request.url, statusCode: self.code, httpVersion: nil, headerFields: nil)!,
                    data: self.data
                )
                combinedBehaviours.received(network: self, request: request, currentResult: .success(networkResponse)) { result in
                    combinedBehaviours.completed(network: self, request: request, result: result)
                    complete(result)
                }
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: task)
            operation.operation = task

            combinedBehaviours.didBegin(network: self, request: request, cancellable: operation)
        }

        return operation
    }
}
