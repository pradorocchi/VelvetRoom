import AppKit
import VelvetRoom

@NSApplicationMain class Window:NSWindow, NSApplicationDelegate, NSWindowDelegate {
    static private(set) var shared:Window!
    private(set) weak var splash:Splash?
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    func applicationDidFinishLaunching(_:Notification) { delegate = self }
    func applicationWillTerminate(_:Notification) { Repository.shared.fireSchedule() }
    func windowWillBeginSheet(_:Notification) { menu!.items.forEach { $0.isEnabled = false } }
    func windowDidEndSheet(_:Notification) { menu!.items.forEach { $0.isEnabled = true } }
    
    func window(_:NSWindow, willPositionSheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.y += 36
        return rect
    }
    
    override func cancelOperation(_:Any?) { makeFirstResponder(nil) }
    override func mouseDown(with:NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView!.wantsLayer = true
        Window.shared = self
        NSApp.delegate = self
        
        let splash = Splash()
        contentView!.addSubview(splash)
        self.splash = splash
        
        splash.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        splash.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        splash.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        splash.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        
        Repository.shared.error = { Alert.shared.add($0) }
        Skin.add(self, selector:#selector(updateSkin))
        DispatchQueue.global(qos:.background).async {
            Repository.shared.load()
            Skin.update()
            DispatchQueue.main.async {
                self.outlets()
            }
        }
    }
    
    @objc func newBoard() { Boarder() }
    
    private func outlets() {
        Toolbar.shared.enabled = true
        
        let canvas = Canvas.shared
        let list = List.shared
        let progress = Progress.shared
        let search = Search.shared
        let gradientLeft = GradientLeft()
        let gradientTop = GradientTop()
        
        splash?.button.isHidden = false
        contentView!.addSubview(canvas, positioned:.below, relativeTo:splash)
        contentView!.addSubview(gradientLeft)
        contentView!.addSubview(list)
        contentView!.addSubview(gradientTop)
        contentView!.addSubview(progress)
        contentView!.addSubview(search)
        
        canvas.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-1).isActive = true
        canvas.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-1).isActive = true
        
        gradientLeft.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        gradientLeft.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        gradientLeft.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        gradientLeft.widthAnchor.constraint(equalToConstant:320).isActive = true
        
        list.widthAnchor.constraint(equalToConstant:250).isActive = true
        list.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        list.left = list.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:-280)
        
        gradientTop.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        gradientTop.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        gradientTop.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        gradientTop.heightAnchor.constraint(equalToConstant:72).isActive = true
        
        progress.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:80).isActive = true
        progress.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-272).isActive = true
        progress.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:10).isActive = true
        progress.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        search.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        search.bottom = search.bottomAnchor.constraint(equalTo:contentView!.topAnchor)
        
        contentView!.layoutSubtreeIfNeeded()
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            gradientTop.alphaValue = 1
            gradientLeft.alphaValue = 1
        }) {
            List.shared.toggle()
        }
    }
    
    @objc private func updateSkin() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            contentView!.layer!.backgroundColor = Skin.shared.background.cgColor
        }, completionHandler:nil)
    }
    
    @IBAction private func showHelp(_ sender:Any?) {
        HelpView().makeKeyAndOrderFront(nil)
    }
}
