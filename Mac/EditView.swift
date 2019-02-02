import AppKit

class EditView:ItemView, NSTextViewDelegate {
    private(set) weak var text:TextView!
    private var dragging = false
    
    override init() {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 6

        let text = TextView()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        text.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        text.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:14).isActive = true
        NotificationCenter.default.addObserver(forName:.init("skin"), object:nil, queue:.main) { _ in
            self.updateSkin()
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            beginEditing()
        }
    }
    
    override func mouseDragged(with event:NSEvent) {
        if !text.isEditable {
            if dragging {
                drag(deltaX:event.deltaX, deltaY:event.deltaY)
                NSCursor.pointingHand.set()
            } else {
                dragging = true
                beginDrag()
                Application.view.makeFirstResponder(nil)
            }
        }
    }
    
    override func mouseUp(with:NSEvent) {
        if dragging {
            dragging = false
            endDrag(with)
        }
    }
    
    func textDidChange(_:Notification) {
        Application.view.canvasChanged()
    }
    
    func textDidEndEditing(_:Notification) {
        Application.view.canvasChanged()
        Application.view.scheduleUpdate()
    }
    
    func beginEditing() {
        text.isEditable = true
        Application.view.makeFirstResponder(text)
    }
    
    func beginDrag() {
        layer!.removeFromSuperlayer()
        superview!.layer!.addSublayer(layer!)
        layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.1).cgColor
    }
    
    func endDrag(_ event:NSEvent) {
        layer!.backgroundColor = NSColor.clear.cgColor
        NSCursor.arrow.set()
    }
    
    func drag(deltaX:CGFloat, deltaY:CGFloat) {
        left.constant += deltaX
        top.constant += deltaY
    }
    
    func updateSkin() {
        text.setNeedsDisplay(text.bounds)
    }
}
