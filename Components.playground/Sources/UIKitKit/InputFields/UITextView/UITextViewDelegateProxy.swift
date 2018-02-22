import UIKit

class UITextViewDelegateProxy: NSObject, UITextViewDelegate {
    // MARK: - Private Properties
    private weak var originalDelegate: UITextViewDelegate?
    private weak var delegate: UITextViewDelegate?

    // MARK: - Lifecycle
    init(item: UITextView) {
        self.originalDelegate = item.delegate

        super.init()

        item.delegate = self
    }

    // MARK: - Public Functions
    func inject(delegate: UITextViewDelegate) {
        self.delegate = delegate
    }

    // MARK: - Delegate Methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let result = originalDelegate?.textViewShouldBeginEditing?(textView) ?? true
        return delegate?.textViewShouldBeginEditing?(textView) ?? result
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let result = originalDelegate?.textViewShouldEndEditing?(textView) ?? true
        return delegate?.textViewShouldEndEditing?(textView) ?? result
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing?(textView)
        originalDelegate?.textViewDidBeginEditing?(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing?(textView)
        originalDelegate?.textViewDidEndEditing?(textView)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let result = originalDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
        return delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? result
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange?(textView)
        originalDelegate?.textViewDidChange?(textView)
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.textViewDidChangeSelection?(textView)
        originalDelegate?.textViewDidChangeSelection?(textView)
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let result = originalDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
        return delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? result
    }
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let result = originalDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
        return delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? result
    }
}
