import UIKit

class EditView:ItemView, UITextViewDelegate {
    private(set) weak var text:TextView!
    private var dragging = false {
        didSet {
            if dragging {
                beginDrag()
            } else {
                endDrag()
            }
        }
    }
    
    override init() {
        super.init()
        layer.cornerRadius = 6
        addGestureRecognizer(UILongPressGestureRecognizer(target:self, action:#selector(longpressed(_:))))
        
        let text = TextView()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        text.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        text.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:14).isActive = true
        text.widthAnchor.constraint(lessThanOrEqualToConstant:250).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
//    override func mouseDown(with event:NSEvent) {
//        if event.clickCount == 2 {
//            beginEditing()
//        }
//    }
//
//    override func mouseDragged(with event:NSEvent) {
//        if !text.isEditable {
//            if dragging {
//                drag(deltaX:event.deltaX, deltaY:event.deltaY)
//                NSCursor.pointingHand.set()
//            } else {
//                dragging = true
//                Application.shared.view.makeFirstResponder(nil)
//            }
//        }
//    }
//
//    override func mouseUp(with:NSEvent) {
//        if dragging {
//            dragging = false
//        }
//    }
    
    func textViewDidChange(_:UITextView) {
        Application.view.canvasChanged(0)
    }
    
    func textViewDidEndEditing(_ textView:UITextView) {
        text.isUserInteractionEnabled = false
        Application.view.canvasChanged()
        Application.view.scheduleUpdate()
    }
    
    func beginEditing() {
        text.isUserInteractionEnabled = true
        text.becomeFirstResponder()
    }
    
    func beginDrag() {
//        layer!.removeFromSuperlayer()
//        superview!.layer!.addSublayer(layer!)
//        layer!.backgroundColor = NSColor.textColor.withAlphaComponent(0.1).cgColor
    }
    
    func endDrag() {
//        layer!.backgroundColor = NSColor.clear.cgColor
    }
    
    func drag(deltaX:CGFloat, deltaY:CGFloat) {
        left.constant += deltaX
        top.constant += deltaY
    }
    
    @objc private func longpressed(_ gesture:UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        beginEditing()
    }
}
