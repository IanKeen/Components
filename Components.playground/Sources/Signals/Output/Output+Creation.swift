public extension Output {
    /// Creates a new `Output`
    ///
    /// - Parameters:
    ///   - value: Optional value to start with
    ///   - equality: Equality function used to block duplicates
    /// - Returns: A tuple containing the `Output` and the function used to send it values
    public static func create(startingWith value: T? = nil, equality: @escaping (T, T) -> Bool) -> (output: Output<T>, send: Updater<T>) {
        let instance = Output(value: value, equality: equality)
        return (instance, instance.send)
    }
}
public extension Output where T: Equatable {
    /// Creates a new `Output`
    ///
    /// - Parameter value: Optional value to start with
    /// - Returns: A tuple containing the `Output` and the function used to send it values
    public static func create(startingWith value: T? = nil) -> (output: Output<T>, send: Updater<T>) {
        return create(startingWith: value, equality: ==)
    }
}

public extension Output {
    /// Provide the initial value for thie `Output`
    public func starting(with value: T) -> Output<T> {
        self.value.update(value)
        return self
    }
}
