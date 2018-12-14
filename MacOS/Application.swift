import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    func applicationDidFinishLaunching(_:Notification) {
        NSApp.windows.first?.delegate = self
    }
}
