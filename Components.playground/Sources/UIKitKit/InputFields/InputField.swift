import UIKit

public protocol InputAdvancementDelegate: class {
    func subscribeAdvancement(_ closure: @escaping (InputField) -> Void)
}

// NOTE: this wrapper is needed because the `UITextInputTraits,returnKeyType` property is _optional_ (thanks objc..)
public protocol UITextInputTraitsType: UITextInputTraits {
    var keyboardReturnKeyType: UIReturnKeyType { get set }
}

public protocol InputField: class {
    typealias FieldType = UITextInputTraitsType & UIResponder

    var field: FieldType { get }

    func advancementDelegate() -> InputAdvancementDelegate
}

extension InputField where Self: UITextInputTraitsType, Self: UIResponder {
    public var field: InputField.FieldType { return self }
}
