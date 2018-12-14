import AppKit

class ColumnView:NSControl {
    private weak var field:NSTextField!
    override var intrinsicContentSize:NSSize { return NSSize(width:200, height:200) }
    
    init(_ name:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let field = NSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.isBezeled = false
        field.isEditable = false
        field.font = NSFont(name:"SFMono-Bold", size:30)
        field.stringValue = name
        field.alphaValue = 0.2
        addSubview(field)
        self.field = field
        
        field.topAnchor.constraint(equalTo:topAnchor, constant:12).isActive = true
        field.leftAnchor.constraint(equalTo:leftAnchor, constant:24).isActive = true
        field.widthAnchor.constraint(equalToConstant:195).isActive = true
        field.heightAnchor.constraint(equalToConstant:100).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
