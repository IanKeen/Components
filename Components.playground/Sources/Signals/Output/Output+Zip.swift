public extension Output {
    public func zip<U, V>(with output: Output<U>, equality: @escaping (V, V) -> Bool, _ combine: @escaping (T, U) -> V) -> Output<V> {
        let result = Output<V>.create(equality: equality)

        let serialQueue = DispatchQueue(label: "zip")
        var left: T? = nil
        var right: U? = nil

        let sendPair = {
            guard let leftValue = left, let rightValue = right else { return }
            defer { left = nil; right = nil }

            result.send(combine(leftValue, rightValue))
        }

        branch(retain: true) { value in
            serialQueue.async {
                left = value
                sendPair()
            }
        }
        output.branch(retain: true) { value in
            serialQueue.async {
                right = value
                sendPair()
            }
        }

        return result.output
    }
    public func zip<U, V: Equatable>(with output: Output<U>, equality: @escaping (V, V) -> Bool, _ combine: @escaping (T, U) -> V) -> Output<V> {
        return zip(with: output, equality: ==, combine)
    }
}

