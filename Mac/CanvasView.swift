import AppKit

class CanvasView:ScrollView {
    private weak var dragging:EditView?
    
    override init() {
        super.init()
        hasHorizontalScroller = true
        horizontalScroller!.controlSize = .mini
        documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:bottomAnchor).isActive = true
        documentView!.rightAnchor.constraint(greaterThanOrEqualTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        if dragging == nil,
            let view = owner(with),
            with.clickCount == 2 {
            view.beginEditing()
        } else {
            mouseUp(with:with)
            Application.view.makeFirstResponder(nil)
        }
    }
    
    override func mouseDragged(with:NSEvent) {
        if dragging == nil {
            guard let view = owner(with) else { return }
            Application.view.makeFirstResponder(nil)
            dragging = view
            view.beginDrag()
        } else {
            dragging!.drag(deltaX:with.deltaX, deltaY:with.deltaY)
            NSCursor.pointingHand.set()
        }
    }
    
    override func mouseUp(with:NSEvent) {
        dragging?.endDrag(with)
        dragging = nil
    }
    
    private func owner(_ event:NSEvent) -> EditView? {
        guard let view = hitTest(event.locationInWindow) else { return nil }
        switch view {
        case is TextView: return view.superview as? EditView
        case is EditView: return view as? EditView
        default: return nil
        }
    }
}
