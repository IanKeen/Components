public extension Output {
    public func filter(_  closure: @escaping (T) -> Bool) -> Output<T> {
        let result = Output<T>.create(equality: equality)
        branch(retain: true) { value in
            guard closure(value) else { return }

            result.send(value)
        }
        return result.output
    }
}
