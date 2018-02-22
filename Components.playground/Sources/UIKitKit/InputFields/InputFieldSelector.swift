import UIKit

public final class InputFieldSelector {
    private class Input {
        let inputField: InputField
        let delegate: InputAdvancementDelegate

        init(inputField: InputField, delegate: InputAdvancementDelegate) {
            self.inputField = inputField
            self.delegate = delegate
        }
    }

    public struct Configuration {
        /// Should the first field become the first responder? default: false
        public let selectFirst: Bool

        /// The `UIReturnKeyType` to use for all fields except the last one. default: .next
        public let returnKeyType: UIReturnKeyType

        /// The `UIReturnKeyType` to use for the last field. default: .go
        public let finalReturnKeyType: UIReturnKeyType

        public init(selectFirst: Bool = false, returnKeyType: UIReturnKeyType = .next, finalReturnKeyType: UIReturnKeyType = .go) {
            self.selectFirst = selectFirst
            self.returnKeyType = returnKeyType
            self.finalReturnKeyType = finalReturnKeyType
        }
    }

    // MARK: - Private Properties
    private var inputs: [Input] = []

    // MARK: - Public Functions
    /// Define an order for the provided `InputField`s - tapping the
    ///  return key on the keyboard will cycle through them in the order provided.
    ///
    /// - Parameters:
    ///   - inputs: The `InputField`s to cycle through
    ///   - configuration: Configuration options for the `InputField`s
    public func cycle(between inputs: [InputField], configuration: Configuration = .init()) {
        self.inputs = inputs.map { inputField in
            let delegate = inputField.advancementDelegate()
            delegate.subscribeAdvancement { [unowned self] in self.moveToResponder(after: $0) }

            inputField.field.keyboardReturnKeyType = configuration.returnKeyType

            return Input(inputField: inputField, delegate: delegate)
        }

        inputs.last?.field.keyboardReturnKeyType = configuration.finalReturnKeyType

        if configuration.selectFirst {
            inputs.first?.field.becomeFirstResponder()
        }
    }

    // MARK: - Private Functions
    private func moveToResponder(after field: InputField) {
        guard
            let current = inputs.index(where: { $0.inputField.field.isFirstResponder }),
            let next = inputs.index(current, offsetBy: 1, limitedBy: inputs.endIndex - 1)
            else { return }

        inputs[next].inputField.field.becomeFirstResponder()
    }
}
