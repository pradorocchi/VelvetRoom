import AppKit
import VelvetRoom

class View:NSWindow {
    let presenter = Presenter()
    private weak var list:ScrollView!
    private weak var canvas:ScrollView!
    private weak var root:ItemView?
    private weak var borderLeft:NSLayoutConstraint!
    @IBOutlet private weak var progress:ProgressView!
    @IBOutlet private weak var listButton:NSButton!
    @IBOutlet private weak var deleteButton:NSButton!
    
    override func cancelOperation(_:Any?) { makeFirstResponder(nil) }
    override func mouseDown(with:NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .textBackgroundColor
        makeOutlets()
        presenter.list = { self.list($0) }
        presenter.select = { self.select($0) }
        presenter.load()
        toggleList(listButton)
    }
    
    func canvasChanged(_ animation:TimeInterval = 0.5) {
        createCard()
        canvas.documentView!.layoutSubtreeIfNeeded()
        align()
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = animation
                context.allowsImplicitAnimation = true
                canvas.documentView!.layoutSubtreeIfNeeded()
            }
        }
    }
    
    func beginDrag(_ card:CardView) { detach(card) }
    func beginDrag(_ column:ColumnView) { detach(column) }
    
    func endDrag(_ card:CardView) {
        var column = root
        while column!.sibling is ColumnView {
            guard column!.sibling!.left.constant < card.frame.midX else { break }
            column = column!.sibling
        }
        var after = column
        while after!.child != nil {
            guard after!.child!.top.constant < card.top.constant else { break }
            after = after!.child
        }
        if after!.child is CreateView {
            after = after?.child
        }
        card.child = after!.child
        after!.child = card
        canvasChanged()
        presenter.move(card.card, column:(column as! ColumnView).column, after:(after as? CardView)?.card)
        presenter.scheduleUpdate()
    }
    
    func endDrag(_ column:ColumnView) {
        var after = root
        if root is CreateView || root!.frame.maxX > column.frame.midX {
            column.sibling = root
            root = column
            after = nil
        } else {
            while after!.sibling is ColumnView {
                guard after!.sibling!.left.constant < column.frame.minX else { break }
                after = after!.sibling
            }
            column.sibling = after!.sibling
            after!.sibling = column
        }
        canvasChanged()
        presenter.move(column.column, after:(after as? ColumnView)?.column)
        presenter.scheduleUpdate()
    }
    
    func delete(_ card:CardView) {
        makeFirstResponder(nil)
        beginSheet(DeleteCardView(card, board:presenter.selected.board, view:self))
    }
    
    func delete(_ column:ColumnView) {
        makeFirstResponder(nil)
        beginSheet(DeleteColumnView(column, board:presenter.selected.board, view:self))
    }
    
    func delete() {
        presenter.fireSchedule()
        makeFirstResponder(nil)
        beginSheet(DeleteBoardView(presenter.selected.board, view:self))
    }
    
    func deleteConfirm(_ card:CardView, board:Board) {
        detach(card)
        card.removeFromSuperview()
        presenter.delete(card.card, board:board)
    }
    
    func deleteConfirm(_ column:ColumnView, board:Board) {
        detach(column)
        var child = column as ItemView?
        while child != nil {
            if !(child is CreateView) {
                child!.removeFromSuperview()
            }
            child = child!.child
        }
        presenter.delete(column.column, board:board)
    }
    
    private func makeOutlets() {
        let list = ScrollView()
        list.hasVerticalScroller = true
        list.verticalScroller!.controlSize = .mini
        contentView!.addSubview(list)
        self.list = list
        
        let canvas = ScrollView()
        canvas.hasVerticalScroller = true
        canvas.hasHorizontalScroller = true
        canvas.verticalScroller!.controlSize = .mini
        canvas.horizontalScroller!.controlSize = .mini
        contentView!.addSubview(canvas)
        self.canvas = canvas
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        contentView!.addSubview(border)
        
        list.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:36).isActive = true
        list.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo:border.leftAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:1).isActive = true
        border.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:1).isActive = true
        border.widthAnchor.constraint(equalToConstant:1).isActive = true
        borderLeft = border.leftAnchor.constraint(equalTo:contentView!.leftAnchor)
        borderLeft.isActive = true
        
        canvas.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:1).isActive = true
        canvas.leftAnchor.constraint(equalTo:border.rightAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-1).isActive = true
        canvas.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-1).isActive = true
        canvas.documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:canvas.bottomAnchor).isActive = true
        canvas.documentView!.rightAnchor.constraint(greaterThanOrEqualTo:canvas.rightAnchor).isActive = true
    }
    
    private func list(_ boards:[Board]) {
        progress.clear()
        deleteButton.isEnabled = false
        canvas.removeSubviews()
        list.removeSubviews()
        var top = list.documentView!.topAnchor
        boards.forEach { board in
            let view = BoardView(board, view:self)
            view.target = self
            view.action = #selector(select(view:))
            list.documentView!.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top).isActive = true
            view.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo:list.rightAnchor).isActive = true
            top = view.bottomAnchor
        }
        list.bottom = list.documentView!.bottomAnchor.constraint(equalTo:top)
    }
    
    private func render(_ board:Board) {
        canvas.removeSubviews()
        root = nil
        var sibling:ItemView?
        board.columns.enumerated().forEach { (index, item) in
            let column = ColumnView(item, view:self)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            canvas.documentView!.addSubview(column)
            var child:ItemView = column
            sibling = column
            
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardView($0, view:self)
                canvas.documentView!.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let buttonColumn = CreateView(self, selector:#selector(newColumn(_:)))
        canvas.documentView!.addSubview(buttonColumn)
        
        if root == nil {
            root = buttonColumn
        } else {
            sibling!.sibling = buttonColumn
        }
    }
    
    private func align() {
        var maxRight = CGFloat(36)
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
        canvas.bottom = canvas.documentView!.heightAnchor.constraint(greaterThanOrEqualToConstant:maxBottom + 16)
        canvas.right = canvas.documentView!.widthAnchor.constraint(greaterThanOrEqualToConstant:maxRight + 16)
    }
    
    private func createCard() {
        guard !(root is CreateView), !(root!.child is CreateView) else { return }
        let create = CreateView(self, selector:#selector(newCard(_:)))
        canvas.documentView!.addSubview(create)
        create.child = root!.child
        root!.child = create    }
    
    private func detach(_ card:CardView) {
        if let parent = canvas.documentView!.subviews.first(where: {($0 as! ItemView).child === card }) as? ItemView {
            parent.child = card.child
            canvasChanged()
        }
    }
    
    private func detach(_ column:ColumnView) {
        if column === root {
            column.child!.removeFromSuperview()
            column.child = column.child!.child
            root = column.sibling
        } else {
            var sibling = root
            while sibling != nil && sibling!.sibling !== column {
                sibling = sibling!.sibling
            }
            sibling?.sibling = column.sibling
        }
        canvasChanged()
    }
    
    private func select(_ board:Board) {
        let view = list.documentView!.subviews.first { ($0 as! BoardView).board.id == board.id } as! BoardView
        select(view:view)
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                context.allowsImplicitAnimation = true
                list.contentView.scrollToVisible(view.frame)
            }
        }
    }
    
    @objc private func select(view:BoardView) {
        makeFirstResponder(nil)
        presenter.selected = view
        render(view.board)
        canvasChanged(0)
        deleteButton.isEnabled = true
        progress.progress(0.5)
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(presenter.newColumn(), view:self)
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
        canvas.documentView!.addSubview(column)
        column.top.constant = view.top.constant
        column.left.constant = view.left.constant
        canvasChanged()
        column.beginEditing()
        presenter.scheduleUpdate()
    }
    
    @objc private func newCard(_ view:CreateView) {
        let card = CardView(presenter.newCard(), view:self)
        card.child = view.child
        view.child = card
        canvas.documentView!.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        presenter.scheduleUpdate()
    }
    
    @IBAction private func toggleSourceList(_ sender:NSMenuItem) {
        switch listButton.state {
        case .on:
            listButton.state = .off
        default:
            listButton.state = .on
        }
        toggleList(listButton)
    }
    
    @IBAction private func toggleList(_ listButton:NSButton) {
        if listButton.state == .on {
            borderLeft.constant = 250
            Application.shared.list.title = .local("View.hideList")
        } else {
            borderLeft.constant = 0
            Application.shared.list.title = .local("View.showList")
        }
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                self.contentView!.layoutSubtreeIfNeeded()
            }
        }
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(NewView(presenter))
    }
    
    @IBAction private func remove(_ sender:Any) {
        makeFirstResponder(nil)
        delete()
    }
}
