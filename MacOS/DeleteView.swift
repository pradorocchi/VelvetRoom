import AppKit

class DeleteView:SheetView {
    private let onConfirm:(() -> Void)
    init(_ name:String, onConfirm:@escaping(() -> Void)) {
        self.onConfirm = onConfirm
        super.init()
        let message = NSTextField()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = .clear
        message.isBezeled = false
        message.isEditable = false
        message.font = .systemFont(ofSize:22, weight:.bold)
        message.textColor = .white
        message.stringValue = name
        contentView!.addSubview(message)
        
        let cancel = NSButton()
        cancel.target = self
        cancel.action = #selector(end)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.attributedTitle = NSAttributedString(string:.local("DeleteView.cancel"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.regular), .foregroundColor:NSColor(white:1, alpha:0.6)])
        cancel.keyEquivalent = "\u{1b}"
        contentView!.addSubview(cancel)
        
        let delete = NSButton()
        delete.image = NSImage(named:"button")
        delete.target = self
        delete.action = #selector(self.delete)
        delete.setButtonType(.momentaryChange)
        delete.imageScaling = .scaleNone
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.isBordered = false
        delete.attributedTitle = NSAttributedString(string:.local("DeleteView.delete"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        delete.keyEquivalent = "\r"
        contentView!.addSubview(delete)
        
        message.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo:delete.topAnchor, constant:-30).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor, constant:20).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:92).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        delete.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant:92).isActive = true
        delete.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    @objc func delete() {
        onConfirm()
        Application.view.endSheet(self)
    }
}
