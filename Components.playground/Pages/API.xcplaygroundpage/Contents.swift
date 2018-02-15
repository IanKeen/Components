/*:
 # API Template

 - Business logic layer that sits on top of a `Network` implementation
 - When `Response` is `Codable` `APIRequest`s require next to no code
 */
private struct Model: CodableEquatable {
    let name: String
    let age: Int
}
private struct ModelRequest: APIRequest {
    typealias Response = Model

    let authenticationRequired = false

    func networkRequest(baseUrl: URL) -> NetworkRequest {
        return NetworkRequest(url: baseUrl.appendingPathComponent("models"))
    }
}

class APITests: XCTestCase {
    func testCodable() throws {
        let data = try JSONSerialization.data(withJSONObject: ["name": "Ian Keen", "age": 42], options: [])
        let api = API(
            network: MockNetwork(code: 200, data: data),
            configuration: .init(
                baseUrl: URL(string: "http://mock.api.com")!,
                commonHeaders: [:],
                authenticationHeaders: { [:] }
            )
        )
        let exp = expectation(description: "")

        try api.perform(request: ModelRequest()) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, Model(name: "Ian Keen", age: 42))
            case .failure(let error):
                XCTFail("\(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
    }
}

APITests.run()
