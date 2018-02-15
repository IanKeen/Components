/*:
 # NetworkKit

 - Raw network request/response only - API logic heeds to be added on top
 - Implementation agnostic, comes with URLSession implementation but can be used with Alamofire for example
 - `NetworkBehaviour`s can be injected to abstract away common network related operations (i.e. showing/hiding network activity indicator)
 */

private func ~=(lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidResponse, .invalidResponse): return true
    case (.clientError, .clientError): return true
    case (.serverError, .serverError): return true
    default: return false
    }
}

class NetworkTests: XCTestCase {
    let url = URL(string: "http://google.com")!

    private func sut(behaviours: [NetworkBehaviour] = [], code: Int = 200, response: Any? = [:]) throws -> (Network, XCTestExpectation) {
        let data = try response.map { try JSONSerialization.data(withJSONObject: $0, options: []) }
        let network = MockNetwork(code: code, data: data)
        network.register(behaviours: behaviours)
        return (network, expectation(description: ""))
    }

    func testBasic() throws {
        let (sut, exp) = try self.sut(response: ["foo": "bar"])

        _ = try sut.perform(request: NetworkRequest(url: url)) { result in
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let response):
                XCTAssertEqual(response, ["foo": "bar"])
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
    }
    func testCancellation() throws {
        let (sut, exp) = try self.sut()

        let task = try sut.perform(request: NetworkRequest(url: url)) { result in
            exp.fulfill()
        }
        task.cancel()

        let result = XCTWaiter().wait(for: [exp], timeout: 2)
        XCTAssertEqual(result, .timedOut)
    }
    func testBehavioursBasic() throws {
        let behaviour = MockBehaviour()
        let (sut, exp) = try self.sut(behaviours: [behaviour])
        ignore(exp)

        _ = try sut.performSync(request: NetworkRequest(url: url))

        XCTAssertEqual(behaviour.events, [.willBegin: 1, .didBegin: 1, .received: 1, .complete: 1])
    }

    func testBehaviours_willBegin() throws {
        let newUrl = URL(string: "http://newurl.com")!
        let behaviour = MockBehaviour(
            willBegin: { _, request, next in
                next(NetworkRequest(url: newUrl))
            }
        )

        let (network, exp) = try sut(behaviours: [behaviour])
        ignore(exp)

        let result = try network.performSync(request: NetworkRequest(url: url))
        XCTAssertEqual(result.response.url, newUrl)
    }
    func testBehaviours_received() throws {
        let behaviour = MockBehaviour(received: { _, request, result, next in
            switch result {
            case .failure: XCTFail()
            case .success(let response):
                XCTAssertEqual(response.response.statusCode, 200)
                XCTAssertEqual(response.data, nil)
                next(.failure("fail"))
            }
        })

        let (network, exp) = try sut(behaviours: [behaviour], code: 200, response: nil)
        ignore(exp)

        do {
            _ = try network.performSync(request: NetworkRequest(url: url))
            XCTFail()
        } catch let error {
            XCTAssertEqual(error as! String, "fail")
        }
    }

    func testBehaviour_statusCode() throws {
        let behaviour = HTTPStatusCodeBehaviour()
        let request = NetworkRequest(url: url)

        do {
            let (network, exp) = try sut(behaviours: [behaviour])
            ignore(exp)

            let result = try network.performSync(request: request)
            XCTAssertEqual(result.response.statusCode, 200)
        }

        do {
            let (network, exp) = try sut(behaviours: [behaviour], code: 400)
            ignore(exp)

            _ = try network.performSync(request: request)
            XCTFail()

        } catch let error as NetworkError {
            let expectedError = NetworkError.clientError(
                request: request,
                response: NetworkResponse(response: HTTPURLResponse(), data: nil)
            )
            XCTAssertTrue(error ~= expectedError)
        } catch {
            XCTFail()
        }
    }
    func testBehaviourNetworkActivity() throws {
        class MockActivityProvider: NetworkActivityProvider {
            var isNetworkActivityIndicatorVisible: Bool = false
        }
        let mockProvider = MockActivityProvider()
        let activityBehaviour = NetworkActivityBehaviour(networkActivityProvider: mockProvider)
        let mockBehaviour = MockBehaviour(
            didBegin: { _, _, _ in
                XCTAssertTrue(mockProvider.isNetworkActivityIndicatorVisible)
            }
        )

        let (network, exp) = try sut(behaviours: [activityBehaviour, mockBehaviour])
        ignore(exp)

        _ = try network.performSync(request: NetworkRequest(url: url))
        XCTAssertFalse(mockProvider.isNetworkActivityIndicatorVisible)
    }
}

NetworkTests.run()

