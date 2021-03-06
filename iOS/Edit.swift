import UIKit
import VelvetRoom

class Edit:Item, UITextViewDelegate {
    private(set) weak var text:Text!
    private(set) weak var dragGesture:UIPanGestureRecognizer!
    private weak var longGesture:UILongPressGestureRecognizer!
    private var dragX:CGFloat!
    private var dragY:CGFloat!
    
    override init() {
        super.init()
        layer.cornerRadius = 4
        
        let dragGesture = UIPanGestureRecognizer(target:self, action:#selector(drag(_:)))
        addGestureRecognizer(dragGesture)
        self.dragGesture = dragGesture
        
        let longGesture = UILongPressGestureRecognizer(target:self, action:#selector(long(_:)))
        addGestureRecognizer(longGesture)
        self.longGesture = longGesture
        
        let text = Text()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        text.topAnchor.constraint(equalTo:topAnchor, constant:16).isActive = true
        text.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-16).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-16).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:16).isActive = true
        text.widthAnchor.constraint(lessThanOrEqualToConstant:
            App.shared.rootViewController!.view.frame.width < 600 ? 220 : 420).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textViewDidChange(_:UITextView) {
        Canvas.shared.update()
    }
    
    func textViewDidEndEditing(_:UITextView) {
        dragGesture.isEnabled = true
        text.isUserInteractionEnabled = false
        Canvas.shared.update()
        Repository.shared.scheduleUpdate(List.shared.selected.board)
    }
    
    func beginEditing() {
        dragGesture.isEnabled = false
        text.isUserInteractionEnabled = true
        text.becomeFirstResponder()
    }
    
    func beginDrag() {
        UIApplication.shared.keyWindow!.endEditing(true)
        dragX = 0
        dragY = 0
        longGesture.isEnabled = false
        superview!.bringSubviewToFront(self)
        backgroundColor = Skin.shared.over
    }
    
    func endDrag() {
        longGesture.isEnabled = true
        backgroundColor = .clear
        Canvas.shared.update()
        Repository.shared.scheduleUpdate(List.shared.selected.board)
        Progress.shared.update()
    }
    
    func drag(deltaX:CGFloat, deltaY:CGFloat) {
        left.constant += deltaX
        top.constant += deltaY
    }
    
    @objc private func drag(_ gesture:UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: beginDrag()
        case .cancelled, .ended, .failed: endDrag()
        case .possible, .changed:
            let point = gesture.translation(in:superview)
            drag(deltaX:point.x - dragX, deltaY:point.y - dragY)
            dragX = point.x
            dragY = point.y
        }
    }
    
    @objc private func long(_ gesture:UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        beginEditing()
    }
}
