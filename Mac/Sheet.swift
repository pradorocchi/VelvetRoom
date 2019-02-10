import AppKit

class Sheet:NSView {
    override var acceptsFirstResponder:Bool { return true }
    
    override func keyDown(with event:NSEvent) {
        if event.keyCode == 53 { close() }
    }
    
    @discardableResult init() {
        Toolbar.shared.enabled = false
        Menu.shared.enabled = false
        Window.shared.makeFirstResponder(nil)
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        alphaValue = 0
        layer!.backgroundColor = Skin.shared.background.withAlphaComponent(0.95).cgColor
        Window.shared.contentView!.addSubview(self)
        
        let terminate = NSButton()
        terminate.title = String()
        terminate.target = self
        terminate.action = #selector(close)
        terminate.isBordered = false
        terminate.keyEquivalent = "\u{1b}"
        addSubview(terminate)
        
        topAnchor.constraint(equalTo:Window.shared.contentView!.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo:Window.shared.contentView!.bottomAnchor).isActive = true
        leftAnchor .constraint(equalTo:Window.shared.contentView!.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo:Window.shared.contentView!.rightAnchor).isActive = true
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            alphaValue = 1
        }) {
            Window.shared.makeFirstResponder(self)
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    override func mouseDown(with:NSEvent) { }
    override func mouseDragged(with:NSEvent) { }
    override func mouseUp(with:NSEvent) { }
    
    @objc func close() {
        Window.shared.makeFirstResponder(nil)
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            alphaValue = 0
        }) { [weak self] in
            Toolbar.shared.enabled = true
            Menu.shared.enabled = true
            self?.removeFromSuperview()
        }
    }
}
