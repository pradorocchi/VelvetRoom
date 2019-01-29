import AppKit
import VelvetRoom

class View:NSWindow {
    let repository = Repository()
    let alert = Alert()
    weak var root:ItemView?
    private(set) weak var canvas:ScrollView!
    private(set) weak var progress:ProgressView!
    private(set) weak var listRight:NSLayoutConstraint!
    private weak var list:ScrollView!
    private weak var gradient:NSView!
    @IBOutlet private weak var listButton:NSButton!
    @IBOutlet private weak var deleteButton:NSButton!
    @IBOutlet private weak var exportButton:NSButton!
    
    private(set) weak var selected:Board? {
        willSet {
            if let selected = self.selected {
                view(selected)?.selected = false
        } }
        didSet { fireSchedule() }
    }
    
    override func cancelOperation(_:Any?) { makeFirstResponder(nil) }
    override func mouseDown(with:NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeOutlets()
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.select(board) } }
        repository.error = { error in DispatchQueue.main.async { self.alert.add(error) } }
        NotificationCenter.default.addObserver(forName:.init("skin"), object:nil, queue:OperationQueue.main) { _ in
            self.updateSkin()
        }
        DispatchQueue.global(qos:.background).async {
            self.repository.load()
            Application.skin = .appearance(self.repository.account.appearance)
        }
        DispatchQueue.main.async {
            self.toggleList(self.listButton)
            self.updateSkin()
        }
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
        DispatchQueue.global(qos:.background).async {
            guard let board = board ?? self.selected else { return }
            self.repository.scheduleUpdate(board)
        }
    }
    
    func fireSchedule() {
        repository.fireSchedule()
    }
    
    private func makeOutlets() {
        let list = ScrollView()
        contentView!.addSubview(list)
        self.list = list
        
        let canvas = ScrollView()
        canvas.hasHorizontalScroller = true
        canvas.horizontalScroller!.controlSize = .mini
        contentView!.addSubview(canvas)
        self.canvas = canvas
        
        let gradient = NSView()
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.layer = CAGradientLayer()
        (gradient.layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (gradient.layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (gradient.layer as! CAGradientLayer).locations = [0, 1]
        gradient.wantsLayer = true
        contentView!.addSubview(gradient)
        self.gradient = gradient
        
        let progress = ProgressView()
        self.progress = progress
        contentView!.addSubview(progress)
        
        gradient.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        gradient.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        gradient.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        gradient.heightAnchor.constraint(equalToConstant:72).isActive = true
        
        list.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        list.widthAnchor.constraint(equalToConstant:250).isActive = true
        listRight = list.rightAnchor.constraint(equalTo:contentView!.leftAnchor)
        listRight.isActive = true
        
        progress.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:80).isActive = true
        progress.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-240).isActive = true
        progress.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:10).isActive = true
        
        canvas.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo:list.rightAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-1).isActive = true
        canvas.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-1).isActive = true
        canvas.documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:canvas.bottomAnchor).isActive = true
        canvas.documentView!.rightAnchor.constraint(greaterThanOrEqualTo:canvas.rightAnchor).isActive = true
        
        contentView!.layoutSubtreeIfNeeded()
    }
    
    private func list(_ boards:[Board]) {
        selected = nil
        deleteButton.isEnabled = false
        exportButton.isEnabled = false
        progress.clear()
        canvas.removeSubviews()
        list.removeSubviews()
        var top = list.documentView!.topAnchor
        boards.enumerated().forEach { board in
            let view = BoardView(board.element)
            view.target = self
            view.action = #selector(select(view:))
            list.documentView!.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top, constant:board.offset == 0 ? 36 : 0).isActive = true
            view.leftAnchor.constraint(equalTo:list.leftAnchor, constant:-8).isActive = true
            view.rightAnchor.constraint(equalTo:list.rightAnchor).isActive = true
            top = view.bottomAnchor
        }
        list.bottom = list.documentView!.bottomAnchor.constraint(equalTo:top, constant:20)
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
        var maxRight = CGFloat(66)
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
        let create = CardCreateView(#selector(newCard(_:)))
        create.child = root!.child
        root!.child = create
        canvas.documentView!.addSubview(create)
    }
    
    private func select(_ board:Board) {
        let boardView = view(board)!
        select(view:boardView)
        DispatchQueue.main.async {
            if #available(OSX 10.12, *) {
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.3
                    context.allowsImplicitAnimation = true
                    self.list.contentView.scrollToVisible(boardView.frame)
                }
            }
        }
    }
    
    private func view(_ board:Board) -> BoardView? {
        return list.documentView!.subviews.first(where: { ($0 as! BoardView).board === board } ) as? BoardView
    }
    
    private func updateSkin() {
        backgroundColor = Application.skin.background
        (gradient.layer as! CAGradientLayer).colors = [Application.skin.background.withAlphaComponent(0).cgColor,
                                                       Application.skin.background.cgColor]
        progress.layer!.borderColor = Application.skin.text.withAlphaComponent(0.2).cgColor
        progress.layer!.backgroundColor = Application.skin.background.cgColor
        canvas.horizontalScroller!.knobStyle = Application.skin.scroller
    }
    
    @objc private func select(view:BoardView) {
        makeFirstResponder(nil)
        view.selected = true
        selected = view.board
        canvas.alphaValue = 0
        render(view.board)
        canvasChanged(0)
        deleteButton.isEnabled = true
        exportButton.isEnabled = true
        progress.progress = view.board.progress
        if #available(OSX 10.12, *) {
            DispatchQueue.main.async {
                self.canvas.contentView.scrollToVisible(CGRect(x:0, y:0, width:1, height:1))
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.7
                    context.allowsImplicitAnimation = true
                    self.canvas.alphaValue = 1
                }
            }
        } else {
            canvas.alphaValue = 1
        }
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(repository.newColumn(selected!))
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
        let card = CardView(try! repository.newCard(selected!))
        card.child = view.child
        view.child = card
        canvas.documentView!.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        scheduleUpdate()
        progress.progress = selected!.progress
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
            listRight.constant = 250
            Application.list.title = .local("View.hideList")
        } else {
            listRight.constant = -30
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
        beginSheet(ChartView(selected!))
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(NewView())
    }
    
    @IBAction private func remove(_ sender:Any) {
        if let selected = self.selected {
            view(selected)?.delete()
        }
    }
    
    @IBAction private func export(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ExportView(selected!))
    }
    
    @IBAction private func load(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(ImportView())
    }
    
    @IBAction private func settings(_ sender:Any) {
        makeFirstResponder(nil)
        beginSheet(SettingsView())
    }
    
    @IBAction private func showHelp(_ sender:Any?) {
        HelpView().makeKeyAndOrderFront(nil)
    }
}
