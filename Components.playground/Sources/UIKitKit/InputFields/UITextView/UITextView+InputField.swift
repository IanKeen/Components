import UIKit

extension UITextView: InputField, UITextInputTraitsType {
    public func advancementDelegate() -> InputAdvancementDelegate {
        return UITextViewAdvancementDelegate(item: self)
    }
    public var keyboardReturnKeyType: UIReturnKeyType {
        get { return self.returnKeyType }
        set { self.returnKeyType = newValue }
    }
}
