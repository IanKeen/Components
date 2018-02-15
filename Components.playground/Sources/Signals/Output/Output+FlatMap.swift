public extension Output {
    public func flatMap<U>(equality: @escaping (U, U) -> Bool, _ closure: @escaping (T) -> Output<U>) -> Output<U> {
        let result = Output<U>(value: nil, equality: equality)
        branch(retain: true) { value in
            let inner = closure(value)
            inner.branch(retain: false) { value in
                result.send(value)
            }
        }
        return result
    }
    public func flatMap<U: Equatable>(_ closure: @escaping (T) -> Output<U>) -> Output<U> {
        return flatMap(equality: ==, closure)
    }
}
