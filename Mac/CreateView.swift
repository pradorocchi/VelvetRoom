import AppKit

class CreateView:Item {
    let selector:Selector
    init(_ selector:Selector, key:String) {
        self.selector = selector
        super.init()
        widthAnchor.constraint(equalToConstant:64).isActive = true
        heightAnchor.constraint(equalToConstant:50).isActive = true
        
        let image = NSImageView()
        image.image = NSImage(named:"new")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let button = NSButton()
        button.title = String()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.target = self
        button.action = #selector(shortcut)
        button.keyEquivalent = key
        button.keyEquivalentModifierMask = [.shift, .command]
        addSubview(button)
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        perform(selector, with:self)
        NSAnimationContext.runAnimationGroup( { context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            alphaValue = 0.2
        } ) { [weak self] in
            self?.alphaValue = 1
        }
    }
    
    @objc private func shortcut() { perform(selector, with:self) }
}
