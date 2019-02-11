import AppKit
import VelvetRoom

class Canvas:NSScrollView {
    static let shared = Canvas()
    weak var root:Item?
    private weak var dragging:Edit?
    private weak var right:NSLayoutConstraint? { willSet { right?.isActive = false; newValue?.isActive = true } }
    private weak var bottom:NSLayoutConstraint? { willSet { bottom?.isActive = false; newValue?.isActive = true } }
    
    private init() {
        super.init(frame:.zero)
        drawsBackground = false
        translatesAutoresizingMaskIntoConstraints = false
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo:topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        hasHorizontalScroller = true
        horizontalScroller!.controlSize = .mini
        documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:bottomAnchor).isActive = true
        documentView!.rightAnchor.constraint(greaterThanOrEqualTo:rightAnchor).isActive = true
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
                context.duration = 1.2
                context.allowsImplicitAnimation = true
                self.alphaValue = 1
            }, completionHandler:nil)
        }
    }
    
    @objc func newColumn() {
        var view = root
        while view?.sibling != nil {
            view = view?.sibling
        }
        if let view = view as? Create {
            newColumn(view)
        }
    }
    
    @objc func newCard() {
        if let view = root?.child as? Create {
            newCard(view)
        }
    }
    
    private func render(_ board:Board) {
        documentView!.subviews.forEach { $0.removeFromSuperview() }
        root = nil
        var sibling:Item?
        board.columns.enumerated().forEach { index, item in
            let column = ColumnItem(item)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            documentView!.addSubview(column)
            var child = column as Item
            sibling = column
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardItem($0)
                documentView!.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let columner = Create(#selector(newColumn(_:)), key:"m")
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
        if root != nil, !(root is Create), !(root!.child is Create) {
            let columner = Create(#selector(newCard(_:)), key:"n")
            columner.child = root!.child
            root!.child = columner
            documentView!.addSubview(columner)
        }
    }
    
    private func owner(_ event:NSEvent) -> Edit? {
        guard let view = hitTest(event.locationInWindow) else { return nil }
        switch view {
        case is Text: return view.superview as? Edit
        case is Edit: return view as? Edit
        default: return nil
        }
    }
    
    @objc private func updateSkin() {
        horizontalScroller!.knobStyle = Skin.shared.scroller
        DispatchQueue.main.async { self.update(0) }
    }
    
    @objc private func newColumn(_ view:Create) {
        let column = ColumnItem(Repository.shared.newColumn(List.shared.current!.board))
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
        Repository.shared.scheduleUpdate(List.shared.current!.board)
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.7
                context.allowsImplicitAnimation = true
                self.contentView.scrollToVisible(CGRect(x:view.frame.minX + self.bounds.width,
                                                        y:view.frame.minY - self.bounds.height, width:1, height:1))
            }, completionHandler:nil)
        }
    }
    
    @objc private func newCard(_ view:Create) {
        let card = CardItem(try! Repository.shared.newCard(List.shared.current!.board))
        card.child = view.child
        view.child = card
        documentView!.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        update()
        card.beginEditing()
        Repository.shared.scheduleUpdate(List.shared.current!.board)
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.7
                context.allowsImplicitAnimation = true
                self.contentView.scrollToVisible(CGRect(x:view.frame.minX - self.bounds.width, y:
                    view.frame.minY - self.bounds.height, width:1, height:1))
            }, completionHandler:nil)
        }
    }
}
