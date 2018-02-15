import Foundation

public extension Network {
    /// Perform a `NetworkRequest` synchronously
    ///
    /// - Parameters:
    ///   - request: The `NetworkRequest` to perform
    ///   - behaviours: `NetworkBehaviour`s that will _only_ be used for this request
    /// - Returns: A `NetworkResult` representing the success or failure of this request
    public func performSync(request: NetworkRequest, behaviours: [NetworkBehaviour] = []) throws -> NetworkResponse {
        let group = DispatchGroup()
        group.enter()

        var value: NetworkResponse? = nil
        var error: Error? = nil

        try self.perform(request: request, behaviours: behaviours) { result in
            switch result {
            case .success(let response):
                value = response
            case .failure(let e):
                error = e
            }
            group.leave()
        }

        group.wait()

        switch (value, error) {
        case (let value?, nil):
            return value
        case (nil, let error?):
            throw error
        default:
            fatalError("Invalid state, this should never happen")
        }
    }
}
