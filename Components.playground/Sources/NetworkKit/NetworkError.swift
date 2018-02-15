import Foundation

/// A set of standard errors that a `Network` may produce
///
/// - invalidResponse: The response was not valid
/// - clientError: The response status code was 4xx
/// - serverError: The response status code was 5xx
public enum NetworkError: Error {
    case invalidResponse(Any)
    case clientError(request: NetworkRequest, response: NetworkResponse)
    case serverError(request: NetworkRequest, response: NetworkResponse)
}

public extension Error {
    public var isURLCancelled: Bool {
        let error = self as NSError
        switch (error.domain, error.code) {
        case (NSURLErrorDomain, NSURLErrorCancelled):
            return true
        default:
            return false
        }
    }

    public var isInternetOffline: Bool {
        let error = self as NSError
        switch (error.domain, error.code) {
        case (NSURLErrorDomain, NSURLErrorNotConnectedToInternet):
            return true
        default:
            return false
        }
    }
}
