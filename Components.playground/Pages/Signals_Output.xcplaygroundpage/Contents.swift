/*:
 # Output<T>

 - Lightweight observable that can emit values over time
 - No concept of 'failure' - so it never terminates
 - Agressive ownership rules to ensure you are retaining correctly
 - Separation of output and input allows only exposing the ability to emit values to things that require it
 */

import Foundation

func &&(lhs: Output<Bool>, rhs: Output<Bool>) -> Output<Bool> {
    return lhs.flatMap { left in
        rhs.map { $0 && left }
    }
}

class OutputTests: XCTestCase {
    func testCleanup_Subscription() {
        // setup a graph and then dealloc the source subscription
        // assert subscription count is 0 before and after
    }
    func testCleanup_Output() {
        // setup a graph and then dealloc the source _output_
        // assert subscription count is 0 before and after
        //
        // maybe add a counter to Output also to double check??
    }
    func testMap() {
        //
    }
    func testFlatMap() {
        //
    }
    func testFilter() {
        //
    }
    func testZip() {
        //
    }
    func testGlitch() {
        let exp = expectation(description: "")
        XCTAssertEqual(Subscription.TotalSubscriptions, 0)
        var source: Subscription? = nil
        var output: [Bool] = []

        do {
            // Example taken from https://talk.objc.io/episodes/S01E76-understanding-reactive-glitches
            let airplaneMode = Output<Bool>.create(startingWith: false)
            let cellular = Output<Bool>.create(startingWith: true)
            let wifi = Output<Bool>.create(startingWith: true)

            let notAirplaneMode = airplaneMode.output.map { !$0 }

            let cellularEnabled = notAirplaneMode && cellular.output
            let wifiEnabled = notAirplaneMode && wifi.output
            let wifiAndCellular = wifiEnabled && cellularEnabled

            source = wifiAndCellular.subscribe {
                output.append($0)
            }

            airplaneMode.send(true)
            airplaneMode.send(false)
            DispatchQueue.main.async {
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1)
        source = nil
        XCTAssertEqual(output, [true, false, true])
        XCTAssertEqual(Subscription.TotalSubscriptions, 0)
    }
}

OutputTests.run()
