import AppKit
import VelvetRoom

@NSApplicationMain class View:NSWindow, NSApplicationDelegate, NSWindowDelegate {
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
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
        
        contentView!.addSubview(Canvas.shared)
        contentView!.addSubview(GradientLeft())
        contentView!.addSubview(List.shared)
        contentView!.addSubview(GradientTop())
        contentView!.addSubview(Progress.shared)
        contentView!.addSubview(Search.shared)
 
        contentView!.layoutSubtreeIfNeeded()
        Repository.shared.error = { Alert.shared.add($0) }
        Skin.add(self, selector:#selector(updateSkin))
        DispatchQueue.main.async {
            self.updateSkin()
            List.shared.toggle()
            DispatchQueue.global(qos:.background).async {
                Repository.shared.load()
                Skin.update()
            }
        }
    }
    
    @objc private func updateSkin() {
        backgroundColor = Skin.shared.background
    }
    
    @IBAction private func play(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ChartView(List.shared.current!.board))
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(NewView())
    }
    
    @IBAction private func remove(_ sender:Any) {
        List.shared.current?.delete()
    }
    
    @IBAction private func export(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ExportView(List.shared.current!.board))
    }
    
    @IBAction private func load(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ImportView())
    }
    
    @IBAction private func settings(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(SettingsView())
    }
    
    @IBAction private func performFindPanelAction(_ sender:Any) {
        makeFirstResponder(nil)
        Search.shared.active()
    }
    
    @IBAction private func showHelp(_ sender:Any?) {
        HelpView().makeKeyAndOrderFront(nil)
    }
}
