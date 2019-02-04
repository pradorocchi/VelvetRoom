import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    static var shared:Application { return NSApp.delegate as! Application }
    var skin = Skin() { didSet { Skin.post() } }
    private(set) weak var view:View!
    @IBOutlet private(set) weak var list:NSMenuItem!
    @IBOutlet private(set) weak var newColumn:NSMenuItem!
    @IBOutlet private(set) weak var newCard:NSMenuItem!
    @IBOutlet private(set) weak var find:NSMenuItem!
    
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    override init() {
        super.init()
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
    }
    
    func applicationDidFinishLaunching(_:Notification) {
        view = NSApp.windows.first as? View
        view.delegate = self
    }
    
    func applicationWillTerminate(_:Notification) {
        view.fireSchedule()
    }
    
    func windowWillBeginSheet(_:Notification) {
        view.menu!.items.forEach { $0.isEnabled = false }
    }
    
    func windowDidEndSheet(_:Notification) {
        view.menu!.items.forEach { $0.isEnabled = true }
    }
    
    func window(_:NSWindow, willPositionSheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.y += 36
        return rect
    }
}
