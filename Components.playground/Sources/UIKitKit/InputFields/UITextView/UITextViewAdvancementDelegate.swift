import UIKit

class UITextViewAdvancementDelegate: NSObject, UITextViewDelegate, InputAdvancementDelegate {
    // MARK: - Private Properties
    private let delegate: UITextViewDelegateProxy
    private var advancement: ((InputField) -> Void)?

    // MARK: - Lifecycle
    init(item: UITextView) {
        self.delegate = UITextViewDelegateProxy(item: item)

        super.init()

        delegate.inject(delegate: self)
    }

    // MARK: - Advancement
    func subscribeAdvancement(_ closure: @escaping (InputField) -> Void) {
        advancement = closure
    }

    // MARK: - Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }

        advancement?(textView)
        return false
    }
}
