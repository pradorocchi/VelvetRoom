import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    private(set) static weak var view:View!
    private(set) static weak var list:NSMenuItem!
    static var skin = Skin() { didSet { NotificationCenter.default.post(name:.init("skin"), object:nil) } }
    
    @IBOutlet private(set) weak var list:NSMenuItem! {
        get { return Application.list }
        set { Application.list = newValue }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    override init() {
        super.init()
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
    }
    
    func applicationDidFinishLaunching(_:Notification) {
        Application.view = NSApp.windows.first as? View
        Application.view.delegate = self
        
        print(NSColor.selectedTextBackgroundColor.usingColorSpace(.deviceRGB))
    }
    
    func applicationWillTerminate(_:Notification) {
        Application.view.fireSchedule()
    }
    
    func windowWillBeginSheet(_ notification: Notification) {
        Application.view.menu!.items.forEach { $0.isEnabled = false }
    }
    
    func windowDidEndSheet(_ notification: Notification) {
        Application.view.menu!.items.forEach { $0.isEnabled = true }
    }
    
    func window(_:NSWindow, willPositionSheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.y += 36
        return rect
    }
}
