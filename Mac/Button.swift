import AppKit

class Button:NSButton {
    init(_ title:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        image = NSImage(named:"button")
        setButtonType(.momentaryChange)
        imageScaling = .scaleNone
        isBordered = false
        attributedTitle = NSAttributedString(string:title, attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        widthAnchor.constraint(equalToConstant:92).isActive = true
        heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with event: NSEvent) {
        sendAction(action, to:target)
    }
}
