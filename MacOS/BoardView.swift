import AppKit

class BoardView:NSControl {
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:50) }
    
    init(_ text:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        name.isBezeled = false
        name.isEditable = false
        name.font = .systemFont(ofSize:16, weight:.bold)
        name.stringValue = text
        name.alphaValue = 0.5
        name.maximumNumberOfLines = 1
        addSubview(name)
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
