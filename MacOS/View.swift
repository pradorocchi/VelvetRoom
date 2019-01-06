import AppKit
import VelvetRoom

class View:NSWindow {
    let repository = Repository()
    weak var root:ItemView?
    private(set) weak var canvas:ScrollView!
    private(set) weak var borderLeft:NSLayoutConstraint!
    private weak var list:ScrollView!
    @IBOutlet private(set) weak var progress:ProgressView!
    @IBOutlet private weak var listButton:NSButton!
    @IBOutlet private weak var deleteButton:NSButton!
    @IBOutlet private weak var exportButton:NSButton!
    
    weak var selected:BoardView! {
        willSet {
            if let previous = selected {
                previous.selected = false
            }
        }
        didSet {
            selected.selected = true
            fireSchedule()
        }
    }
    
    override func cancelOperation(_:Any?) { makeFirstResponder(nil) }
    override func mouseDown(with:NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .textBackgroundColor
        makeOutlets()
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.select(board) } }
        DispatchQueue.global(qos:.background).async { self.repository.load() }
        DispatchQueue.main.async { self.toggleList(self.listButton) }
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
    
    func scheduleUpdate(_ board:Board? = nil) {
        DispatchQueue.global(qos:.background).async { self.repository.scheduleUpdate(board ?? self.selected.board) }
    }
    
    func fireSchedule() {
        repository.fireSchedule()
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
        border.layer!.backgroundColor = NSColor.textColor.withAlphaComponent(0.2).cgColor
        contentView!.addSubview(border)
        
        list.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:36).isActive = true
        list.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo:border.leftAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant:1).isActive = true
        borderLeft = border.leftAnchor.constraint(equalTo:contentView!.leftAnchor)
        borderLeft.isActive = true
        
        canvas.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:36).isActive = true
        canvas.leftAnchor.constraint(equalTo:border.rightAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-1).isActive = true
        canvas.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-1).isActive = true
        canvas.documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:canvas.bottomAnchor).isActive = true
        canvas.documentView!.rightAnchor.constraint(greaterThanOrEqualTo:canvas.rightAnchor).isActive = true
        
        contentView!.layoutSubtreeIfNeeded()
    }
    
    private func list(_ boards:[Board]) {
        deleteButton.isEnabled = false
        exportButton.isEnabled = false
        progress.clear()
        canvas.removeSubviews()
        list.removeSubviews()
        var top = list.documentView!.topAnchor
        boards.forEach { board in
            let view = BoardView(board)
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
            let column = ColumnView(item)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            canvas.documentView!.addSubview(column)
            var child:ItemView = column
            sibling = column
            
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardView($0)
                canvas.documentView!.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let buttonColumn = CreateView(#selector(newColumn(_:)))
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
            var bottom = CGFloat(20)
            
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
        let create = CreateView(#selector(newCard(_:)))
        create.child = root!.child
        root!.child = create
        canvas.documentView!.addSubview(create)
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
        selected = view
        render(view.board)
        canvasChanged(0)
        deleteButton.isEnabled = true
        exportButton.isEnabled = true
        progress.progress = view.board.progress
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(repository.newColumn(selected.board))
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
        scheduleUpdate()
    }
    
    @objc private func newCard(_ view:CreateView) {
        let card = CardView(try! repository.newCard(selected.board))
        card.child = view.child
        view.child = card
        canvas.documentView!.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        scheduleUpdate()
        progress.progress = selected.board.progress
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
            Application.list.title = .local("View.hideList")
        } else {
            borderLeft.constant = 0
            Application.list.title = .local("View.showList")
        }
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                contentView!.layoutSubtreeIfNeeded()
            }
        }
    }
    
    @IBAction private func play(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ChartView(selected.board))
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(NewView())
    }
    
    @IBAction private func remove(_ sender:Any) {
        makeFirstResponder(nil)
        selected.delete()
    }
    
    @IBAction private func export(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ExportView(selected.board))
    }
}
