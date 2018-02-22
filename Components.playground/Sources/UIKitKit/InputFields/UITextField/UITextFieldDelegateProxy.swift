import UIKit

class UITextFieldDelegateProxy: NSObject, UITextFieldDelegate {
    // MARK: - Private Properties
    private weak var originalDelegate: UITextFieldDelegate?
    private weak var delegate: UITextFieldDelegate?

    // MARK: - Lifecycle
    init(item: UITextField) {
        self.originalDelegate = item.delegate

        super.init()

        item.delegate = self
    }

    // MARK: - Public Functions
    func inject(delegate: UITextFieldDelegate) {
        self.delegate = delegate
    }

    // MARK: - Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let result = originalDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        return delegate?.textFieldShouldBeginEditing?(textField) ?? result
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField)
        originalDelegate?.textFieldDidBeginEditing?(textField)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let result = originalDelegate?.textFieldShouldEndEditing?(textField) ?? true
        return delegate?.textFieldShouldEndEditing?(textField) ?? result
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
        originalDelegate?.textFieldDidEndEditing?(textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        delegate?.textFieldDidEndEditing?(textField, reason: reason)
        originalDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = originalDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        return delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? result
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let result = originalDelegate?.textFieldShouldClear?(textField) ?? true
        return delegate?.textFieldShouldClear?(textField) ?? result
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let result = originalDelegate?.textFieldShouldReturn?(textField) ?? true
        return delegate?.textFieldShouldReturn?(textField) ?? result
    }
}
