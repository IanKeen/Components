import UIKit

extension UITextField: InputField, UITextInputTraitsType {
    public func advancementDelegate() -> InputAdvancementDelegate {
        return UITextFieldAdvancementDelegate(item: self)
    }
    public var keyboardReturnKeyType: UIReturnKeyType {
        get { return self.returnKeyType }
        set { self.returnKeyType = newValue }
    }
}
