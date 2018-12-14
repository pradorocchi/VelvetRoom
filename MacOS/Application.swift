import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
}
