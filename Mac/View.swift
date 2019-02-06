import AppKit
import VelvetRoom

@NSApplicationMain class View:NSWindow, NSApplicationDelegate, NSWindowDelegate {
    let repository = Repository()
    private(set) weak var progress:ProgressView!
    
    private weak var gradientTop:NSView!
    private weak var gradientLeft:NSView!
    private weak var search:SearchView!
    
    private(set) weak var selected:Board? {
        willSet {
            if let selected = self.selected {
                view(selected)?.selected = false
        } }
        didSet { repository.fireSchedule() }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    func applicationDidFinishLaunching(_:Notification) { delegate = self }
    func applicationWillTerminate(_:Notification) { repository.fireSchedule() }
    func windowWillBeginSheet(_:Notification) { menu!.items.forEach { $0.isEnabled = false } }
    func windowDidEndSheet(_:Notification) { menu!.items.forEach { $0.isEnabled = true } }
    
    func window(_:NSWindow, willPositionSheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.y += 36
        return rect
    }
    
    override func cancelOperation(_:Any?) { makeFirstResponder(nil) }
    override func mouseDown(with:NSEvent) { makeFirstResponder(nil) }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
        makeOutlets()
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.select(board) } }
        repository.error = { error in DispatchQueue.main.async { self.alert.add(error) } }
        Skin.add(self, selector:#selector(updateSkin))
        DispatchQueue.main.async {
            self.toggleList(self.listButton)
            self.updateSkin()
            DispatchQueue.global(qos:.background).async {
                self.repository.load()
                Skin.update(self.repository.account.appearance, font:self.repository.account.font)
            }
        }
    }
    
    func canvasChanged(_ animation:TimeInterval = 0.5) {
        createCard()
        View.canvas.documentView!.layoutSubtreeIfNeeded()
        align()
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animation
            context.allowsImplicitAnimation = true
            View.canvas.documentView!.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    func scheduleUpdate(_ board:Board? = nil) {
        DispatchQueue.global(qos:.background).async {
            guard let board = board ?? self.selected else { return }
            self.repository.scheduleUpdate(board)
        }
    }
    
    private func makeOutlets() {
        let canvas = CanvasView()
        contentView!.addSubview(canvas)
        View.canvas = canvas
        
        let gradientLeft = NSView()
        gradientLeft.translatesAutoresizingMaskIntoConstraints = false
        gradientLeft.layer = CAGradientLayer()
        (gradientLeft.layer as! CAGradientLayer).startPoint = CGPoint(x:0, y:0.5)
        (gradientLeft.layer as! CAGradientLayer).endPoint = CGPoint(x:1, y:0.5)
        (gradientLeft.layer as! CAGradientLayer).locations = [0, 0.7, 1]
        gradientLeft.wantsLayer = true
        contentView!.addSubview(gradientLeft)
        self.gradientLeft = gradientLeft
        
        let list = ScrollView()
        contentView!.addSubview(list)
        self.list = list
        
        let gradientTop = NSView()
        gradientTop.translatesAutoresizingMaskIntoConstraints = false
        gradientTop.layer = CAGradientLayer()
        (gradientTop.layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (gradientTop.layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (gradientTop.layer as! CAGradientLayer).locations = [0, 1]
        gradientTop.wantsLayer = true
        contentView!.addSubview(gradientTop)
        self.gradientTop = gradientTop
        
        let progress = ProgressView()
        self.progress = progress
        contentView!.addSubview(progress)
        
        let search = SearchView()
        contentView!.addSubview(search)
        self.search = search
        
        gradientTop.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        gradientTop.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        gradientTop.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        gradientTop.heightAnchor.constraint(equalToConstant:72).isActive = true
        
        gradientLeft.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        gradientLeft.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        gradientLeft.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        gradientLeft.widthAnchor.constraint(equalToConstant:320).isActive = true
        
        list.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        list.widthAnchor.constraint(equalToConstant:250).isActive = true
        listLeft = list.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:-280)
        listLeft.isActive = true
        
        progress.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:80).isActive = true
        progress.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-272).isActive = true
        progress.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:10).isActive = true
        
        canvas.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:contentView!.rightAnchor, constant:-1).isActive = true
        canvas.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-1).isActive = true
        
        search.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        
        contentView!.layoutSubtreeIfNeeded()
    }
    
    private func list(_ boards:[Board]) {
        selected = nil
        deleteButton.isEnabled = false
        searchButton.isEnabled = false
        exportButton.isEnabled = false
        chartButton.isEnabled = false
        menuFind.isEnabled = false
        menuColumn.isEnabled = false
        menuCard.isEnabled = false
        progress.chart = []
        View.canvas.removeSubviews()
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
        View.canvas.removeSubviews()
        View.canvas.root = nil
        var sibling:ItemView?
        board.columns.enumerated().forEach { (index, item) in
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
    
    private func createCard() {
        guard View.canvas.root != nil, !(root is CreateView), !(root!.child is CreateView) else { return }
        let create = CreateView(#selector(newCard(_:)), key:"n")
        create.child = View.canvas.root!.child
        View.canvas.root!.child = create
        View.canvas.documentView!.addSubview(create)
    }
    
    private func select(_ board:Board) {
        let boardView = view(board)!
        select(view:boardView)
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                context.allowsImplicitAnimation = true
                self.list.contentView.scrollToVisible(boardView.frame)
            }, completionHandler:nil)
        }
    }
    
    private func view(_ board:Board) -> BoardView? {
        return list.documentView!.subviews.first(where: { ($0 as! BoardView).board === board } ) as? BoardView
    }
    
    @objc private func updateSkin() {
        backgroundColor = Application.shared.skin.background
        (gradientTop.layer as! CAGradientLayer).colors = [
            Application.shared.skin.background.withAlphaComponent(0).cgColor,
            Application.shared.skin.background.cgColor]
        (gradientLeft.layer as! CAGradientLayer).colors = [
            Application.shared.skin.background.cgColor,
            Application.shared.skin.background.withAlphaComponent(0.9).cgColor,
            Application.shared.skin.background.withAlphaComponent(0).cgColor]
        canvas.horizontalScroller!.knobStyle = Application.shared.skin.scroller
        DispatchQueue.main.async { if self.selected != nil { self.canvasChanged(0) } }
    }
    
    @objc private func select(view:BoardView) {
        makeFirstResponder(nil)
        view.selected = true
        selected = view.board
        View.canvas.alphaValue = 0
        render(view.board)
        canvasChanged(0)
        deleteButton.isEnabled = true
        searchButton.isEnabled = true
        exportButton.isEnabled = true
        chartButton.isEnabled = true
        menuFind.isEnabled = true
        menuColumn.isEnabled = true
        menuCard.isEnabled = true
        progress.chart = selected!.chart
        DispatchQueue.main.async {
            View.canvas.contentView.scrollToVisible(CGRect(x:0, y:0, width:1, height:1))
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                View.canvas.alphaValue = 1
            }, completionHandler:nil)
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
        View.canvas.documentView!.addSubview(column)
        column.top.constant = view.top.constant
        column.left.constant = view.left.constant
        canvasChanged()
        column.beginEditing()
        scheduleUpdate()
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.7
                context.allowsImplicitAnimation = true
                View.canvas.contentView.scrollToVisible(CGRect(x:view.frame.minX + View.canvas.bounds.width, y:
                    view.frame.minY - View.canvas.bounds.height, width:1, height:1))
            }, completionHandler:nil)
        }
    }
    
    @objc private func newCard(_ view:CreateView) {
        let card = CardView(try! repository.newCard(selected!))
        card.child = view.child
        view.child = card
        View.canvas.documentView!.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        scheduleUpdate()
        progress.chart = selected!.chart
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.7
                context.allowsImplicitAnimation = true
                View.canvas.contentView.scrollToVisible(CGRect(x:view.frame.minX - View.canvas.bounds.width, y:
                    view.frame.minY - View.canvas.bounds.height, width:1, height:1))
            }, completionHandler:nil)
        }
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
            listLeft.constant = 0
            menuList.title = .local("View.hideList")
        } else {
            listLeft.constant = -280
            menuList.title = .local("View.showList")
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            contentView!.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
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
    
    @IBAction private func performFindPanelAction(_ sender:Any) {
        makeFirstResponder(nil)
        search.active()
    }
    
    @IBAction private func showHelp(_ sender:Any?) {
        HelpView().makeKeyAndOrderFront(nil)
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
