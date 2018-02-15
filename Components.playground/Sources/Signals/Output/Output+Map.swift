public extension Output {
    public func map<U>(equality: @escaping (U, U) -> Bool, _ closure: @escaping (T) -> U) -> Output<U> {
        let result = Output<U>(value: nil, equality: equality)
        branch(retain: true) { result.send(closure($0)) }
        return result
    }
    public func map<U: Equatable>(_ closure: @escaping (T) -> U) -> Output<U> {
        return map(equality: ==, closure)
    }
}
