import AppKit

class Sheet:NSView {
    @discardableResult init() {
        Toolbar.shared.enabled = false
        Menu.shared.enabled = false
        Window.shared.makeFirstResponder(nil)
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        alphaValue = 0
        layer!.backgroundColor = Skin.shared.background.cgColor
        Window.shared.contentView!.addSubview(self)
        
        topAnchor.constraint(equalTo:Window.shared.contentView!.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo:Window.shared.contentView!.bottomAnchor).isActive = true
        leftAnchor .constraint(equalTo:Window.shared.contentView!.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo:Window.shared.contentView!.rightAnchor).isActive = true
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            alphaValue = 0.95
        }, completionHandler:nil)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc func close() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            alphaValue = 0
        }) {
            self.removeFromSuperview()
            Toolbar.shared.enabled = true
            Menu.shared.enabled = true
        }
    }
}
