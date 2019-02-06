import AppKit
import VelvetRoom

class Canvas:ScrollView {
    static let shared = Canvas()
    private weak var root:ItemView?
    private weak var dragging:EditView?
    
    private override init() {
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
            Application.shared.view.makeFirstResponder(nil)
        }
    }
    
    override func mouseDragged(with:NSEvent) {
        if dragging == nil {
            guard let view = owner(with) else { return }
            Application.shared.view.makeFirstResponder(nil)
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
    
    func update(_ animation:TimeInterval = 0.5) {
        createCard()
        documentView!.layoutSubtreeIfNeeded()
        align()
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animation
            context.allowsImplicitAnimation = true
            documentView!.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    func render(_ board:Board) {
        removeSubviews()
        root = nil
        var sibling:ItemView?
        board.columns.enumerated().forEach { index, item in
            let column = ColumnView(item)
            if sibling == nil {
                View.canvas.root = column
            } else {
                sibling!.sibling = column
            }
            View.canvas.documentView!.addSubview(column)
            var child:ItemView = column
            sibling = column
            
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardView($0)
                View.canvas.documentView!.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let buttonColumn = CreateView(#selector(newColumn(_:)), key:"m")
        View.canvas.documentView!.addSubview(buttonColumn)
        
        if View.canvas.root == nil {
            View.canvas.root = buttonColumn
        } else {
            sibling!.sibling = buttonColumn
        }
    }
    
    private func align() {
        var maxRight = CGFloat(316)
        var maxBottom = CGFloat()
        var sibling = View.canvas.root
        while sibling != nil {
            let right = maxRight
            var bottom = CGFloat(56)
            var child = sibling
            sibling = sibling!.sibling
            while child != nil {
                child!.left.constant = right
                child!.top.constant = bottom
                
                bottom += child!.bounds.height + 20
                maxRight = max(maxRight, right + child!.bounds.width + 20)
                
                child = child!.child
            }
            
            maxBottom = max(bottom, maxBottom)
        }
        View.canvas.bottom = canvas.documentView!.heightAnchor.constraint(greaterThanOrEqualToConstant:maxBottom + 16)
        View.canvas.right = canvas.documentView!.widthAnchor.constraint(greaterThanOrEqualToConstant:maxRight + 16)
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
