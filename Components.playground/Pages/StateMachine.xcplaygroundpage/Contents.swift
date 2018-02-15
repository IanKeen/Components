/*:
 # StateMachine

 - Transition between states using injectable logic
 - Makes it impossible to end up in an undefined state
 */
enum State {
    case loggedOut, loggedIn
}
enum Event {
    case logIn, logOut
}

class StateMachineTests: XCTestCase {
    private let machine = StateMachine<State, Event>(startingWith: .loggedOut) { state, event in
        switch (state, event) {
        case (.loggedOut, .logIn):
            return .loggedIn
        case (.loggedIn, .logOut):
            return .loggedOut
        default:
            return nil
        }
    }

    func testTransitions() {
        var count = 0
        let exp = expectation(description: "")

        machine.onStateUpdate.subscribe { _ in
            count += 1
        }

        machine.transition(with: .logOut) // shouldn't trigger
        machine.transition(with: .logIn) // loggedOut > loggedIn
        machine.transition(with: .logIn) // shouldn't trigger
        machine.transition(with: .logOut) // loggedIn > loggedOut

        DispatchQueue.main.async {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
        XCTAssertEqual(count, 2)
    }
}

StateMachineTests.run()
