import AppKit
import VelvetRoom

class SettingsView:SheetView {
    private weak var dark:NSButton!
    private weak var system:NSButton!
    private weak var light:NSButton!
    private weak var font:NSTextField!
    private weak var appearanceTitle:NSTextField!
    private weak var darkTitle:NSTextField!
    private weak var systemTitle:NSTextField!
    private weak var lightTitle:NSTextField!
    private weak var fontTitle:NSTextField!
    private weak var slider:NSSlider?
    private weak var timer:Timer!
    
    override init() {
        super.init()
        let close = NSButton()
        close.target = self
        close.action = #selector(end)
        close.image = NSImage(named:"close")
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
        appearanceTitle.stringValue = .local("SettingsView.appearanceTitle")
        contentView!.addSubview(appearanceTitle)
        self.appearanceTitle = appearanceTitle
        
        let dark = NSButton()
        dark.target = self
        dark.action = #selector(makeDark)
        dark.image = NSImage(named:"dark")
        dark.imageScaling = .scaleNone
        dark.translatesAutoresizingMaskIntoConstraints = false
        dark.isBordered = false
        dark.title = String()
        contentView!.addSubview(dark)
        self.dark = dark
        
        let system = NSButton()
        system.target = self
        system.action = #selector(makeSystem)
        system.image = NSImage(named:"default")
        system.imageScaling = .scaleNone
        system.translatesAutoresizingMaskIntoConstraints = false
        system.isBordered = false
        system.title = String()
        contentView!.addSubview(system)
        self.system = system
        
        let light = NSButton()
        light.target = self
        light.action = #selector(makeLight)
        light.image = NSImage(named:"light")
        light.imageScaling = .scaleNone
        light.translatesAutoresizingMaskIntoConstraints = false
        light.isBordered = false
        light.title = String()
        contentView!.addSubview(light)
        self.light = light
        
        let darkTitle = NSTextField()
        darkTitle.translatesAutoresizingMaskIntoConstraints = false
        darkTitle.backgroundColor = .clear
        darkTitle.isBezeled = false
        darkTitle.isEditable = false
        darkTitle.font = .systemFont(ofSize:12, weight:.light)
        darkTitle.alignment = .center
        darkTitle.stringValue = .local("SettingsView.darkTitle")
        contentView!.addSubview(darkTitle)
        self.darkTitle = darkTitle
        
        let systemTitle = NSTextField()
        systemTitle.translatesAutoresizingMaskIntoConstraints = false
        systemTitle.backgroundColor = .clear
        systemTitle.isBezeled = false
        systemTitle.isEditable = false
        systemTitle.font = .systemFont(ofSize:12, weight:.light)
        systemTitle.alignment = .center
        systemTitle.stringValue = .local("SettingsView.systemTitle")
        contentView!.addSubview(systemTitle)
        self.systemTitle = systemTitle
        
        let lightTitle = NSTextField()
        lightTitle.translatesAutoresizingMaskIntoConstraints = false
        lightTitle.backgroundColor = .clear
        lightTitle.isBezeled = false
        lightTitle.isEditable = false
        lightTitle.font = .systemFont(ofSize:12, weight:.light)
        lightTitle.alignment = .center
        lightTitle.stringValue = .local("SettingsView.lightTitle")
        contentView!.addSubview(lightTitle)
        self.lightTitle = lightTitle
        
        let fontTitle = NSTextField()
        fontTitle.translatesAutoresizingMaskIntoConstraints = false
        fontTitle.backgroundColor = .clear
        fontTitle.isBezeled = false
        fontTitle.isEditable = false
        fontTitle.font = .systemFont(ofSize:16, weight:.medium)
        fontTitle.stringValue = .local("SettingsView.fontTitle")
        contentView!.addSubview(fontTitle)
        self.fontTitle = fontTitle
        
        let font = NSTextField()
        font.translatesAutoresizingMaskIntoConstraints = false
        font.backgroundColor = .clear
        font.isBezeled = false
        font.isEditable = false
        font.font = .systemFont(ofSize:16, weight:.medium)
        font.alignment = .right
        contentView!.addSubview(font)
        self.font = font
        
        let slider = NSSlider()
        slider.target = self
        slider.action = #selector(changeFont(_:))
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minValue = 8
        slider.maxValue = 32
        if #available(OSX 10.12.2, *) {
            slider.trackFillColor = .velvetBlue
        }
        contentView!.addSubview(slider)
        self.slider = slider
        
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
        close.heightAnchor.constraint(equalToConstant:24).isActive = true
        
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
        
        systemTitle.centerXAnchor.constraint(equalTo:system.centerXAnchor).isActive = true
        systemTitle.topAnchor.constraint(equalTo:system.bottomAnchor, constant:5).isActive = true
        
        darkTitle.centerXAnchor.constraint(equalTo:dark.centerXAnchor).isActive = true
        darkTitle.topAnchor.constraint(equalTo:systemTitle.topAnchor).isActive = true
        
        lightTitle.centerXAnchor.constraint(equalTo:light.centerXAnchor).isActive = true
        lightTitle.topAnchor.constraint(equalTo:systemTitle.topAnchor).isActive = true
        
        fontTitle.topAnchor.constraint(equalTo:systemTitle.bottomAnchor, constant:150).isActive = true
        fontTitle.leftAnchor.constraint(equalTo:appearanceTitle.leftAnchor).isActive = true
        
        font.topAnchor.constraint(equalTo:fontTitle.topAnchor).isActive = true
        font.rightAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:200).isActive = true
        
        slider.topAnchor.constraint(equalTo:fontTitle.bottomAnchor, constant:20).isActive = true
        slider.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        slider.widthAnchor.constraint(equalToConstant:400).isActive = true
        
        done.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        done.widthAnchor.constraint(equalToConstant:92).isActive = true
        done.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        switch Application.view.repository.account.appearance {
        case .light: changeLight()
        case .dark: changeDark()
        case .system: changeSystem()
        }
        
        slider.integerValue = Int(Application.skin.font)
        font.stringValue = "\(slider.integerValue)"
        updateSkin()
        
        NotificationCenter.default.addObserver(forName:.init("skin"), object:nil, queue:.main) { [weak self] _ in
            self?.updateSkin(2)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateSkin(_ animation:TimeInterval = 0) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animation
            context.allowsImplicitAnimation = true
            contentView!.layer!.backgroundColor = Application.skin.background.cgColor
            appearanceTitle.textColor = Application.skin.text
            darkTitle.textColor = Application.skin.text
            systemTitle.textColor = Application.skin.text
            lightTitle.textColor = Application.skin.text
            fontTitle.textColor = Application.skin.text
            font.textColor = Application.skin.text
        }, completionHandler:nil)
    }
    
    private func changeLight() {
        light.alphaValue = 1
        dark.alphaValue = 0.3
        system.alphaValue = 0.3
    }
    
    private func changeDark() {
        light.alphaValue = 0.3
        dark.alphaValue = 1
        system.alphaValue = 0.3
    }
    
    private func changeSystem() {
        light.alphaValue = 0.3
        dark.alphaValue = 0.3
        system.alphaValue = 1
    }
    
    @objc private func makeLight() {
        changeLight()
        Application.view.repository.change(.light)
        Application.skin = .appearance(.light, font:slider!.integerValue)
    }
    
    @objc private func makeDark() {
        changeDark()
        Application.view.repository.change(.dark)
        Application.skin = .appearance(.dark, font:slider!.integerValue)
    }
    
    @objc private func makeSystem() {
        changeSystem()
        Application.view.repository.change(.system)
        Application.skin = .appearance(.system, font:slider!.integerValue)
    }
    
    @objc private func changeFont(_ slider:NSSlider) {
        font.stringValue = "\(slider.integerValue)"
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(save), userInfo:nil, repeats:false)
    }
    
    @objc private func save() {
        guard
            timer?.isValid == true,
            let font = slider?.integerValue
        else { return }
        Application.view.repository.change(font)
        Application.skin.font = CGFloat(font)
    }
}
