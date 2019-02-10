import AppKit

class Label:NSTextField {
    init(_ string:String = String(), color:NSColor = Skin.shared.text, font:NSFont? = nil) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        textColor = color
        isBezeled = false
        isEditable = false
        stringValue = string
        self.font = font
    }
    
    required init?(coder:NSCoder) { return nil }
}
