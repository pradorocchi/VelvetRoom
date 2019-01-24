import AppKit
import VelvetRoom

class SettingsView:SheetView {
    private weak var dark:NSButton!
    private weak var system:NSButton!
    private weak var light:NSButton!
    
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
        close.title = String()
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
        
        let appearanceTitle = NSTextField()
        appearanceTitle.translatesAutoresizingMaskIntoConstraints = false
        appearanceTitle.backgroundColor = .clear
        appearanceTitle.isBezeled = false
        appearanceTitle.isEditable = false
        appearanceTitle.font = .systemFont(ofSize:16, weight:.medium)
        appearanceTitle.textColor = .white
        appearanceTitle.stringValue = .local("SettingsView.appearanceTitle")
        contentView!.addSubview(appearanceTitle)
        
        let dark = NSButton()
        dark.target = self
        dark.action = #selector(end)
        dark.image = NSImage(named:"dark")
        dark.imageScaling = .scaleNone
        dark.translatesAutoresizingMaskIntoConstraints = false
        dark.isBordered = false
        dark.title = String()
        contentView!.addSubview(dark)
        self.dark = dark
        
        let system = NSButton()
        system.target = self
        system.action = #selector(end)
        system.image = NSImage(named:"default")
        system.imageScaling = .scaleNone
        system.translatesAutoresizingMaskIntoConstraints = false
        system.isBordered = false
        system.title = String()
        contentView!.addSubview(system)
        self.system = system
        
        let light = NSButton()
        light.target = self
        light.action = #selector(end)
        light.image = NSImage(named:"light")
        light.imageScaling = .scaleNone
        light.translatesAutoresizingMaskIntoConstraints = false
        light.isBordered = false
        light.title = String()
        contentView!.addSubview(light)
        self.light = light
        
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
        
        appearanceTitle.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:-200).isActive = true
        appearanceTitle.topAnchor.constraint(equalTo:title.bottomAnchor, constant:50).isActive = true
        
        system.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        system.topAnchor.constraint(equalTo:appearanceTitle.bottomAnchor, constant:30).isActive = true
        system.widthAnchor.constraint(equalToConstant:50).isActive = true
        system.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        dark.rightAnchor.constraint(equalTo:system.leftAnchor, constant:-100).isActive = true
        dark.topAnchor.constraint(equalTo:system.topAnchor).isActive = true
        dark.widthAnchor.constraint(equalToConstant:50).isActive = true
        dark.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        light.leftAnchor.constraint(equalTo:system.rightAnchor, constant:100).isActive = true
        light.topAnchor.constraint(equalTo:system.topAnchor).isActive = true
        light.widthAnchor.constraint(equalToConstant:50).isActive = true
        light.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        done.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        done.widthAnchor.constraint(equalToConstant:92).isActive = true
        done.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
}
