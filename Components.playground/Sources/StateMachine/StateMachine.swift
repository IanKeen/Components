/// Enforces predefined transitions between `State`s
public class StateMachine<State, Event> {
    /// A function that defines the possible transitions between `State`s when `Event`s occur.
    ///
    /// - Parameters:
    ///   - state: The current `State`
    ///   - event: The `Event` that occured
    /// - Returns: The new `State` for a valid transition, `nil` for invalid ones.
    public typealias TransitionLogic = (_ state: State, _ event: Event) -> State?

    /// Represents a successful transition from one `State` to another
    public struct Transition {
        public let old: State
        public let new: State
    }

    // MARK: - Private Properties
    private let logic: TransitionLogic
    private let updater: Updater<Transition>

    // MARK: - Public Properties
    /// The current `State`
    public private(set) var state: State {
        didSet { updater(.init(old: oldValue, new: state)) }
    }
    /// `Output` called when a successful transition occurs
    public let onStateUpdate: Output<Transition>

    // MARK: - Lifecycle
    /// Create a new `StateMachine`
    ///
    /// - Parameters:
    ///   - state: The `State` to start with
    ///   - logic: The `TransitionLogic` defining valid transitions.
    public init(startingWith state: State, logic: @escaping TransitionLogic) {
        self.state = state
        self.logic = logic
        (self.onStateUpdate, self.updater) = Output<Transition>.create(equality: notEquatable)
    }

    // MARK: - Public Functions
    /// Attempts to transition from the current `State` using the provided `Event`
    ///
    /// - Parameter event: `Event` to parse to the `TransitionLogic`
    public func transition(with event: Event) {
        guard let newState = logic(state, event) else { return }
        state = newState
    }
}

/// A read only `StateMachine`
public class ReadOnlyStateMachine<State, Event> {
    // MARK: - Private Properties
    private let stateMachine: StateMachine<State, Event>

    // MARK: - Public Properties
    /// The current `State`
    public var state: State { return stateMachine.state }

    /// `Output` called when a successful transition occurs
    public var onStateUpdate: Output<StateMachine<State, Event>.Transition> { return stateMachine.onStateUpdate }

    // MARK: - Lifecycle
    init(stateMachine: StateMachine<State, Event>) {
        self.stateMachine = stateMachine
    }
}

public extension StateMachine {
    /// Create a read only version of a `StateMachine` - allows observation but no ability to update
    public func readOnly() -> ReadOnlyStateMachine<State, Event> {
        return ReadOnlyStateMachine(stateMachine: self)
    }
}


