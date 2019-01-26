import AppKit

class CreateView:ItemView {
    init(_ selector:Selector) {
        super.init()
        widthAnchor.constraint(equalToConstant:64).isActive = true
        heightAnchor.constraint(equalToConstant:40).isActive = true
        action = selector
        
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
        sendAction(action, to:Application.view)
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
