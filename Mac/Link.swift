import AppKit

class Link:NSButton {
    init(_ title:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        setButtonType(.momentaryChange)
        isBordered = false
        attributedTitle = NSAttributedString(string:title, attributes:[.font:
            NSFont.systemFont(ofSize:15, weight:.regular), .foregroundColor:Skin.shared.text.withAlphaComponent(0.6)])
        widthAnchor.constraint(equalToConstant:92).isActive = true
        heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        sendAction(action, to:target)
    }
}
