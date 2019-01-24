import AppKit
import VelvetRoom

class SettingsView:SheetView {
    override init() {
        super.init()
        
        let close = NSButton()
        close.target = self
        close.action = #selector(end)
        close.image = NSImage(named:"delete")
        close.imageScaling = .scaleNone
        close.translatesAutoresizingMaskIntoConstraints = false
        close.isBordered = false
        close.keyEquivalent = "\u{1b}"
        contentView!.addSubview(close)
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:16, weight:.bold)
        title.textColor = .velvetBlue
        title.stringValue = .local("SettingsView.title")
        contentView!.addSubview(title)
        
        let done = NSButton()
        done.image = NSImage(named:"button")
        done.target = self
        done.action = #selector(end)
        done.setButtonType(.momentaryChange)
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.attributedTitle = NSAttributedString(string:.local("SettingsView.done"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        done.keyEquivalent = "\r"
        contentView!.addSubview(done)
        
        close.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        close.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        close.widthAnchor.constraint(equalToConstant:24).isActive = true
        close.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.leftAnchor.constraint(equalTo:close.rightAnchor, constant:10).isActive = true
        title.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        
        done.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        done.widthAnchor.constraint(equalToConstant:92).isActive = true
        done.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
}
