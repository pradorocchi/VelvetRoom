import UIKit

class TextView:UITextView {
    private weak var width:NSLayoutConstraint!
    private weak var height:NSLayoutConstraint!
    override var font:UIFont? {
        didSet {
            let storage = textStorage as! TextStorage
            storage.text = font
            storage.header = .bold(font!.pointSize)
        }
    }
    
    init() {
        let container = NSTextContainer()
        let storage = TextStorage()
        let layout = TextLayout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        isScrollEnabled = false
        isUserInteractionEnabled = false
        backgroundColor = .clear
        tintColor = .velvetBlue
        textColor = .white
        returnKeyType = .default
        keyboardAppearance = .dark
        autocorrectionType = .yes
        spellCheckingType = .yes
        autocapitalizationType = .sentences
        keyboardType = .alphabet
        contentInset = .zero
        textContainerInset = .zero

        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func caretRect(for position:UITextPosition) -> CGRect {
        var rect = super.caretRect(for:position)
        rect.size.width += 4
        return rect
    }
}
