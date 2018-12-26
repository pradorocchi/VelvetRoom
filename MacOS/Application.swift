import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    private(set) static weak var shared:Application!
    private(set) var view:View!
    @IBOutlet private(set) weak var list:NSMenuItem!
    
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    override init() {
        super.init()
        Application.shared = self
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
    }
    
    func applicationDidFinishLaunching(_:Notification) {
        view = NSApp.windows.first as? View
        view.delegate = self
    }
    
    func applicationWillTerminate(_:Notification) {
        view.presenter.fireSchedule()
    }
    
    func windowWillBeginSheet(_ notification: Notification) {
        view.menu!.items.forEach { $0.isEnabled = false }
    }
    
    func windowDidEndSheet(_ notification: Notification) {
        view.menu!.items.forEach { $0.isEnabled = true }
    }
    
    func window(_:NSWindow, willPositionSheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.y += 36
        return rect
    }
}
