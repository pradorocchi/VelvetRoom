import AppKit

class NewItemView:ItemView {
    init(_ target:AnyObject, selector:Selector) {
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant:24).isActive = true
        heightAnchor.constraint(equalToConstant:18).isActive = true
        action = selector
        self.target = target
        
        let image = NSImageView()
        image.image = NSImage(named:"new")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        sendAction(action, to:target)
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup( { context in
                context.duration = 0.2
                context.allowsImplicitAnimation = true
                alphaValue = 0.2
            } ) {
                self.alphaValue = 1
            }
        }
    }
}
