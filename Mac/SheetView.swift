import AppKit

class SheetView:NSWindow {
    override var canBecomeKey:Bool { return true }
    
    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:Window.shared.frame.width - 2, height:
            Window.shared.frame.height - 2), styleMask:[], backing:.buffered, defer:false)
        isOpaque = false
        backgroundColor = .clear
        contentView!.wantsLayer = true
        contentView!.layer!.backgroundColor = NSColor.black.cgColor
        contentView!.layer!.cornerRadius = 4
        preventsApplicationTerminationWhenModal = false
        
        let terminate = NSButton()
        terminate.title = String()
        terminate.target = self
        terminate.action = #selector(self.terminate)
        terminate.isBordered = false
        terminate.keyEquivalent = "q"
        terminate.keyEquivalentModifierMask = .command
        contentView!.addSubview(terminate)
    }
    
    @objc func end() {
        makeFirstResponder(nil)
        Window.shared.endSheet(self)
    }
    
    @objc private func terminate() {
        NSApp.terminate(nil)
    }
}
