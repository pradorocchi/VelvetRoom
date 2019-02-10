import AppKit

class Help:NSWindow {
    override var canBecomeKey:Bool { return true }
    
    init() {
        super.init(contentRect:NSRect(x:0, y:0, width:540, height:320), styleMask:
            [.unifiedTitleAndToolbar, .fullSizeContentView, .closable, .titled], backing:.buffered, defer:false)
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let text = Text()
        text.textContainer!.size = NSSize(width:500, height:300)
        text.font = .light(16)
        text.string = .local("Help.content")
        contentView!.addSubview(text)
        
        text.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:50).isActive = true
        text.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        
        center()
    }
    
    @IBAction private func showHelp(_ sender:Any?) { }
}
