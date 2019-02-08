import AppKit
import VelvetRoom

class Canvas:Scroll {
    static let shared = Canvas()
    weak var root:Item?
    private weak var dragging:EditView?
    
    private override init() {
        super.init()
        hasHorizontalScroller = true
        horizontalScroller!.controlSize = .mini
        documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:bottomAnchor).isActive = true
        documentView!.rightAnchor.constraint(greaterThanOrEqualTo:rightAnchor).isActive = true
        updateSkin()
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        if dragging == nil,
            let view = owner(with),
            with.clickCount == 2 {
            view.beginEditing()
        } else {
            mouseUp(with:with)
            Window.shared.makeFirstResponder(nil)
        }
    }
    
    override func mouseDragged(with:NSEvent) {
        if dragging == nil {
            guard let view = owner(with) else { return }
            Window.shared.makeFirstResponder(nil)
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
        var sibling:Item?
        board.columns.enumerated().forEach { index, item in
            let column = ColumnView(item)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            documentView!.addSubview(column)
            var child = column as Item
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
        case is Text: return view.superview as? EditView
        case is EditView: return view as? EditView
        default: return nil
        }
    }
    
    @objc private func updateSkin() {
        horizontalScroller!.knobStyle = Skin.shared.scroller
        DispatchQueue.main.async { self.update(0) }
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(Repository.shared.newColumn(List.shared.current!.board))
        column.sibling = view
        if root === view {
            root = column
        } else {
            var left = root
            while left!.sibling !== view {
                left = left!.sibling
            }
            left!.sibling = column
        }
        documentView!.addSubview(column)
        column.top.constant = view.top.constant
        column.left.constant = view.left.constant
        update()
        column.beginEditing()
        List.shared.scheduleUpdate()
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.7
                context.allowsImplicitAnimation = true
                self.contentView.scrollToVisible(CGRect(x:view.frame.minX + self.bounds.width,
                                                        y:view.frame.minY - self.bounds.height, width:1, height:1))
            }, completionHandler:nil)
        }
    }
    
    @objc private func newCard(_ view:CreateView) {
        let card = CardView(try! Repository.shared.newCard(List.shared.current!.board))
        card.child = view.child
        view.child = card
        documentView!.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        update()
        card.beginEditing()
        List.shared.scheduleUpdate()
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.7
                context.allowsImplicitAnimation = true
                self.contentView.scrollToVisible(CGRect(x:view.frame.minX - self.bounds.width, y:
                    view.frame.minY - self.bounds.height, width:1, height:1))
            }, completionHandler:nil)
        }
    }
    
    @IBAction private func addRow(_ sender:Any?) {
        var view = root
        while view?.sibling != nil {
            view = view?.sibling
        }
        if let view = view as? CreateView {
            newColumn(view)
        }
    }
    
    @IBAction private func addChild(_ sender:Any?) {
        if let view = root?.child as? CreateView {
            newCard(view)
        }
    }
}
