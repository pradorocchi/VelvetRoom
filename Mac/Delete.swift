import AppKit

class Delete:Sheet {
    private let confirm:(() -> Void)
    
    @discardableResult init(_ name:String, confirm:@escaping(() -> Void)) {
        self.confirm = confirm
        super.init()
        let message = NSTextField()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = .clear
        message.isBezeled = false
        message.isEditable = false
        message.font = .systemFont(ofSize:22, weight:.bold)
        message.textColor = Skin.shared.text
        message.stringValue = name
        addSubview(message)
        
        let cancel = NSButton()
        cancel.target = self
        cancel.action = #selector(close)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.attributedTitle = NSAttributedString(string:.local("DeleteView.cancel"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.regular), .foregroundColor:
            Skin.shared.text.withAlphaComponent(0.8)])
        addSubview(cancel)
        
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
        addSubview(delete)
        
        message.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        message.bottomAnchor.constraint(equalTo:delete.topAnchor, constant:-30).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor, constant:20).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:92).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        delete.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant:92).isActive = true
        delete.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func delete() {
        confirm()
        close()
    }
}
