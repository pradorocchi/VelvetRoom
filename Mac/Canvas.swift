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
            NSApp.mainWindow!.makeFirstResponder(nil)
        }
    }
    
    override func mouseDragged(with:NSEvent) {
        if dragging == nil {
            guard let view = owner(with) else { return }
            NSApp.mainWindow!.makeFirstResponder(nil)
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
        addCarder()
        documentView!.layoutSubtreeIfNeeded()
        align()
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animation
            context.allowsImplicitAnimation = true
            documentView!.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    func display(_ board:Board) {
        alphaValue = 0
        render(board)
        update(0)
        DispatchQueue.main.async {
            self.contentView.scrollToVisible(CGRect(x:0, y:0, width:1, height:1))
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                self.alphaValue = 1
            }, completionHandler:nil)
        }
    }
    
    private func render(_ board:Board) {
        removeSubviews()
        root = nil
        var sibling:ItemView?
        board.columns.enumerated().forEach { index, item in
            let column = ColumnView(item)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            documentView!.addSubview(column)
            var child = column as ItemView
            sibling = column
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardView($0)
                documentView!.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let columner = CreateView(#selector(newColumn(_:)), key:"m")
        documentView!.addSubview(columner)
        
        if root == nil {
            root = columner
        } else {
            sibling!.sibling = columner
        }
    }
    
    private func align() {
        var maxRight = CGFloat(316)
        var maxBottom = CGFloat()
        var sibling = root
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
        bottom = documentView!.heightAnchor.constraint(greaterThanOrEqualToConstant:maxBottom + 16)
        right = documentView!.widthAnchor.constraint(greaterThanOrEqualToConstant:maxRight + 16)
    }
    
    private func addCarder() {
        if root != nil, !(root is CreateView), !(root!.child is CreateView) {
//            let create = CreateView(#selector(newCard(_:)), key:"n")
//            create.child = View.canvas.root!.child
//            View.canvas.root!.child = create
//            View.canvas.documentView!.addSubview(create)
        }
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
