import AppKit

class ImportView:SheetView {
    override init() {
        super.init()
        
        let done = NSButton()
        done.target = self
        done.action = #selector(self.end)
        done.image = NSImage(named:"delete")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.font = .systemFont(ofSize:16, weight:.bold)
        done.keyEquivalent = "\u{1b}"
        contentView!.addSubview(done)
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:16, weight:.bold)
        title.textColor = .velvetBlue
        title.stringValue = .local("ImportView.title")
        contentView!.addSubview(title)
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        image.image = NSImage(named:"drop")
        contentView!.addSubview(image)
        
        let open = NSButton()
        open.image = NSImage(named:"button")
        open.target = self
        open.action = #selector(self.open)
        open.setButtonType(.momentaryChange)
        open.imageScaling = .scaleNone
        open.translatesAutoresizingMaskIntoConstraints = false
        open.isBordered = false
        open.attributedTitle = NSAttributedString(string:.local("ImportView.open"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        open.keyEquivalent = "\r"
        contentView!.addSubview(open)
        
        image.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:120).isActive = true
        image.heightAnchor.constraint(equalToConstant:120).isActive = true
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.centerYAnchor.constraint(equalTo:done.centerYAnchor).isActive = true
        
        open.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        open.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        open.widthAnchor.constraint(equalToConstant:92).isActive = true
        open.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    @objc private func open() {
        
    }
}
