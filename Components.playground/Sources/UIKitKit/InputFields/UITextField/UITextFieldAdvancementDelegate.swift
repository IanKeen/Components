import UIKit

class UITextFieldAdvancementDelegate: NSObject, UITextFieldDelegate, InputAdvancementDelegate {
    // MARK: - Private Properties
    private let delegate: UITextFieldDelegateProxy
    private var advancement: ((InputField) -> Void)?

    // MARK: - Lifecycle
    init(item: UITextField) {
        self.delegate = UITextFieldDelegateProxy(item: item)

        super.init()
        
        delegate.inject(delegate: self)
    }

    // MARK: - Advancement
    func subscribeAdvancement(_ closure: @escaping (InputField) -> Void) {
        advancement = closure
    }

    // MARK: - Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        advancement?(textField)
        return false
    }
}
