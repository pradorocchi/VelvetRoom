import AppKit

class ColumnView:NSControl {
    private weak var name:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:150, height:50) }
    
    init(_ text:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        name.isBezeled = false
        name.isEditable = false
        name.font = .bold(22)
        name.stringValue = text
        name.alphaValue = 0.4
        name.maximumNumberOfLines = 1
        addSubview(name)
        self.name = name
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:10).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
