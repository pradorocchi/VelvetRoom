import AppKit

class DeleteView:NSWindow {
    private(set) weak var view:View!
    private(set) weak var message:NSTextField!
    override var canBecomeKey:Bool { return true }
    
    init(_ view:View) {
        super.init(contentRect:NSRect(x:0, y:0, width:Application.shared.view.frame.width - 2, height:
            Application.shared.view.frame.height - 2), styleMask:[], backing:.buffered, defer:false)
        isOpaque = false
        backgroundColor = .clear
        contentView!.wantsLayer = true
        contentView!.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        contentView!.layer!.cornerRadius = 4
        self.view = view
        
        let message = NSTextField()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = .clear
        message.isBezeled = false
        message.isEditable = false
        message.font = .systemFont(ofSize:18, weight:.bold)
        message.alignment = .center
        contentView!.addSubview(message)
        self.message = message
        
        let cancel = NSButton()
        cancel.title = .local("DeleteView.cancel")
        cancel.target = self
        cancel.action = #selector(self.cancel)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = .systemFont(ofSize:15, weight:.regular)
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
        Application.shared.view.endSheet(self)
    }
    
    @objc private func cancel() {
        Application.shared.view.endSheet(self)
    }
}
