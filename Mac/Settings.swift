import AppKit
import VelvetRoom

class Settings:Sheet {
    private weak var dark:NSButton!
    private weak var system:NSButton!
    private weak var light:NSButton!
    private weak var font:NSTextField!
    private weak var appearanceTitle:NSTextField!
    private weak var darkTitle:NSTextField!
    private weak var systemTitle:NSTextField!
    private weak var lightTitle:NSTextField!
    private weak var fontTitle:NSTextField!
    private weak var slider:NSSlider!
    private weak var track:NSView!
    private weak var timer:Timer!
    
    @discardableResult override init() {
        super.init()
        let appearanceTitle = NSTextField()
        appearanceTitle.translatesAutoresizingMaskIntoConstraints = false
        appearanceTitle.backgroundColor = .clear
        appearanceTitle.isBezeled = false
        appearanceTitle.isEditable = false
        appearanceTitle.font = .systemFont(ofSize:16, weight:.medium)
        appearanceTitle.stringValue = .local("SettingsView.appearanceTitle")
        addSubview(appearanceTitle)
        self.appearanceTitle = appearanceTitle
        
        let dark = NSButton()
        dark.target = self
        dark.action = #selector(makeDark)
        dark.image = NSImage(named:"dark")
        dark.imageScaling = .scaleNone
        dark.translatesAutoresizingMaskIntoConstraints = false
        dark.isBordered = false
        dark.title = String()
        addSubview(dark)
        self.dark = dark
        
        let system = NSButton()
        system.target = self
        system.action = #selector(makeSystem)
        system.image = NSImage(named:"default")
        system.imageScaling = .scaleNone
        system.translatesAutoresizingMaskIntoConstraints = false
        system.isBordered = false
        system.title = String()
        addSubview(system)
        self.system = system
        
        let light = NSButton()
        light.target = self
        light.action = #selector(makeLight)
        light.image = NSImage(named:"light")
        light.imageScaling = .scaleNone
        light.translatesAutoresizingMaskIntoConstraints = false
        light.isBordered = false
        light.title = String()
        addSubview(light)
        self.light = light
        
        let darkTitle = NSTextField()
        darkTitle.translatesAutoresizingMaskIntoConstraints = false
        darkTitle.backgroundColor = .clear
        darkTitle.isBezeled = false
        darkTitle.isEditable = false
        darkTitle.font = .systemFont(ofSize:12, weight:.regular)
        darkTitle.alignment = .center
        darkTitle.stringValue = .local("SettingsView.darkTitle")
        addSubview(darkTitle)
        self.darkTitle = darkTitle
        
        let systemTitle = NSTextField()
        systemTitle.translatesAutoresizingMaskIntoConstraints = false
        systemTitle.backgroundColor = .clear
        systemTitle.isBezeled = false
        systemTitle.isEditable = false
        systemTitle.font = .systemFont(ofSize:12, weight:.regular)
        systemTitle.alignment = .center
        systemTitle.stringValue = .local("SettingsView.systemTitle")
        addSubview(systemTitle)
        self.systemTitle = systemTitle
        
        let lightTitle = NSTextField()
        lightTitle.translatesAutoresizingMaskIntoConstraints = false
        lightTitle.backgroundColor = .clear
        lightTitle.isBezeled = false
        lightTitle.isEditable = false
        lightTitle.font = .systemFont(ofSize:12, weight:.regular)
        lightTitle.alignment = .center
        lightTitle.stringValue = .local("SettingsView.lightTitle")
        addSubview(lightTitle)
        self.lightTitle = lightTitle
        
        let fontTitle = NSTextField()
        fontTitle.translatesAutoresizingMaskIntoConstraints = false
        fontTitle.backgroundColor = .clear
        fontTitle.isBezeled = false
        fontTitle.isEditable = false
        fontTitle.font = .systemFont(ofSize:16, weight:.medium)
        fontTitle.stringValue = .local("SettingsView.fontTitle")
        addSubview(fontTitle)
        self.fontTitle = fontTitle
        
        let font = NSTextField()
        font.translatesAutoresizingMaskIntoConstraints = false
        font.backgroundColor = .clear
        font.isBezeled = false
        font.isEditable = false
        font.font = .systemFont(ofSize:16, weight:.medium)
        font.alignment = .right
        addSubview(font)
        self.font = font
        
        let track = NSView()
        track.translatesAutoresizingMaskIntoConstraints = false
        track.wantsLayer = true
        track.layer!.cornerRadius = 1.5
        addSubview(track)
        self.track = track
        
        let slider = NSSlider()
        slider.target = self
        slider.action = #selector(changeFont)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minValue = 8
        slider.maxValue = 32
        addSubview(slider)
        self.slider = slider
        
        let done = Button(.local("SettingsView.done"))
        done.target = self
        done.action = #selector(self.close)
        done.keyEquivalent = "\r"
        addSubview(done)
        
        appearanceTitle.leftAnchor.constraint(equalTo:centerXAnchor, constant:-200).isActive = true
        appearanceTitle.topAnchor.constraint(equalTo:topAnchor, constant:40).isActive = true
        
        system.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
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
        
        fontTitle.topAnchor.constraint(equalTo:systemTitle.bottomAnchor, constant:80).isActive = true
        fontTitle.leftAnchor.constraint(equalTo:appearanceTitle.leftAnchor).isActive = true
        
        font.topAnchor.constraint(equalTo:fontTitle.topAnchor).isActive = true
        font.rightAnchor.constraint(equalTo:centerXAnchor, constant:200).isActive = true
        
        track.centerYAnchor.constraint(equalTo:slider.centerYAnchor).isActive = true
        track.heightAnchor.constraint(equalToConstant:3).isActive = true
        track.leftAnchor.constraint(equalTo:slider.leftAnchor, constant:1).isActive = true
        track.rightAnchor.constraint(equalTo:slider.rightAnchor, constant:-1).isActive = true
        
        slider.topAnchor.constraint(equalTo:fontTitle.bottomAnchor, constant:20).isActive = true
        slider.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        slider.widthAnchor.constraint(equalToConstant:400).isActive = true
        
        done.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-20).isActive = true
        
        switch Repository.shared.account.appearance {
        case .light: changeLight()
        case .dark: changeDark()
        case .system: changeSystem()
        }
        
        slider.integerValue = Int(Skin.shared.font)
        font.stringValue = "\(slider.integerValue)"
        updateSkin()
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    @objc private func updateSkin() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            layer!.backgroundColor = Skin.shared.background.withAlphaComponent(0.95).cgColor
            appearanceTitle.textColor = Skin.shared.text
            darkTitle.textColor = Skin.shared.text
            systemTitle.textColor = Skin.shared.text
            lightTitle.textColor = Skin.shared.text
            fontTitle.textColor = Skin.shared.text
            font.textColor = Skin.shared.text
            track.layer!.backgroundColor = Skin.shared.text.withAlphaComponent(0.2).cgColor
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
        Repository.shared.change(.light)
        Skin.update(.light, font:slider.integerValue)
    }
    
    @objc private func makeDark() {
        changeDark()
        Repository.shared.change(.dark)
        Skin.update(.dark, font:slider.integerValue)
    }
    
    @objc private func makeSystem() {
        changeSystem()
        Repository.shared.change(.system)
        Skin.update(.system, font:slider.integerValue)
    }
    
    @objc private func changeFont(_ slider:NSSlider) {
        font.stringValue = "\(slider.integerValue)"
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(save), userInfo:nil, repeats:false)
    }
    
    @objc private func save() {
        guard timer?.isValid == true else { return }
        Repository.shared.change(slider.integerValue)
        Skin.shared.font = CGFloat(slider.integerValue)
    }
}
