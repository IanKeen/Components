public func XCTAssertEqual(_ expression1: NetworkResponse, _ expression2: [String: Any], _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    let data = try? JSONSerialization.data(withJSONObject: expression2, options: [])
    let string = data.flatMap { String(data: $0, encoding: .utf8) }

    XCTAssertEqual(expression1.string, string, message, file: file, line: line)
}
