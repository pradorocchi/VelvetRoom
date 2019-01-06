import AppKit

class SheetView:NSWindow {
    override var canBecomeKey:Bool { return true }
    
    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:Application.view.frame.width - 2, height:
            Application.view.frame.height - 2), styleMask:[], backing:.buffered, defer:false)
        isOpaque = false
        backgroundColor = .clear
        contentView!.wantsLayer = true
        contentView!.layer!.backgroundColor = NSColor.black.cgColor
        contentView!.layer!.cornerRadius = 4
    }
    
    @objc func end() {
        makeFirstResponder(nil)
        Application.view.endSheet(self)
    }
}
