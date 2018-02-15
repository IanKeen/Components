public class HTTPStatusCodeBehaviour: NetworkRequestReceivedBehaviour {
    public init() { }

    public func requestReceived(network: Network, request: NetworkRequest, currentResult: NetworkResult, next: @escaping NetworkRequestReceivedBehaviour.RequestReceivedHandler) {
        switch currentResult {
        case .success(let response):
            let code = response.response.statusCode
            var result = currentResult

            if code >= 400 && code <= 499 {
                result = .failure(NetworkError.clientError(request: request, response: response))

            } else if code >= 500 && code <= 599 {
                result = .failure(NetworkError.serverError(request: request, response: response))
            }
            
            next(result)

        case .failure:
            next(currentResult)
        }
    }
}
