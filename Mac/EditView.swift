import AppKit

class EditView:Item, NSTextViewDelegate {
    private(set) weak var text:Text!
    
    override init() {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 6

        let text = Text()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        text.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        text.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:14).isActive = true
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func textDidChange(_:Notification) {
        Canvas.shared.update()
    }
    
    func textDidEndEditing(_:Notification) {
        Canvas.shared.update()
        List.shared.scheduleUpdate()
    }
    
    func beginEditing() {
        text.isEditable = true
        Window.shared.makeFirstResponder(text)
    }
    
    func beginDrag() {
        layer!.removeFromSuperlayer()
        superview!.layer!.addSublayer(layer!)
        layer!.backgroundColor = Skin.shared.text.withAlphaComponent(0.1).cgColor
    }
    
    func endDrag(_ event:NSEvent) {
        layer!.backgroundColor = NSColor.clear.cgColor
        NSCursor.arrow.set()
    }
    
    func drag(deltaX:CGFloat, deltaY:CGFloat) {
        left.constant += deltaX
        top.constant += deltaY
    }
    
    @objc func updateSkin() {
        text.setNeedsDisplay(text.bounds)
    }
}
