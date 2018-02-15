/*:
 # Input<T>

 - Encapsulates access to a function that may take time to complete
 - Blocks subsequent attempts to run the code when it is currently running
 - Provides an `Output<Bool>` for monitoring executing
 */


import Foundation

class InputTests: XCTestCase {
    func testBasic() {
        let exp = expectation(description: "")
        let input = Input<Int> { value, done in
            XCTAssertEqual(value, 0)
            exp.fulfill()
            done()
        }

        input.execute(value: 0)
        wait(for: [exp], timeout: 1)
    }
    func testWorking() {
        var working: [Bool] = []

        let exp = expectation(description: "")
        let input = Input<Int> { _, done in
            done()
        }

        input.working.subscribe { value in
            working.append(value)

            guard working.count == 3 else { return }
            exp.fulfill()
        }

        input.execute(value: 0)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(working, [false, true, false])
    }
    func testBarrier() {
        var values: [Int] = []

        let exp = expectation(description: "")
        let input = Input<Int> { value, done in
            values.append(value)
        }

        input.execute(value: 0)
        input.execute(value: 0)
        input.execute(value: 0)

        DispatchQueue.main.async {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
        XCTAssertEqual(values, [0])
    }
}

InputTests.run()
