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
        
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(string:.local("ImportView.title"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.bold), .foregroundColor:NSColor.velvetBlue]))
        mutable.append(NSAttributedString(string:.local("ImportView.description"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.ultraLight), .foregroundColor:NSColor.white]))
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.attributedStringValue = mutable
        contentView!.addSubview(title)
        
        let drop = DropView()
        contentView!.addSubview(drop)
        
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
        
        drop.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        drop.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        drop.widthAnchor.constraint(equalToConstant:120).isActive = true
        drop.heightAnchor.constraint(equalToConstant:120).isActive = true
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.topAnchor.constraint(equalTo:done.topAnchor).isActive = true
        
        open.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        open.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        open.widthAnchor.constraint(equalToConstant:92).isActive = true
        open.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    @objc private func open() {
        
    }
}
