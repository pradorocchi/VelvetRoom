import AppKit
import VelvetRoom

@NSApplicationMain class View:NSWindow, NSApplicationDelegate, NSWindowDelegate {
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    func applicationDidFinishLaunching(_:Notification) { delegate = self }
    func applicationWillTerminate(_:Notification) { Repository.shared.fireSchedule() }
    func windowWillBeginSheet(_:Notification) { menu!.items.forEach { $0.isEnabled = false } }
    func windowDidEndSheet(_:Notification) { menu!.items.forEach { $0.isEnabled = true } }
    
    func window(_:NSWindow, willPositionSheet:NSWindow, using rect:NSRect) -> NSRect {
        var rect = rect
        rect.origin.y += 36
        return rect
    }
    
    override func cancelOperation(_:Any?) { makeFirstResponder(nil) }
    override func mouseDown(with:NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
        
        contentView!.addSubview(Canvas.shared)
        contentView!.addSubview(GradientLeft())
        contentView!.addSubview(List.shared)
        contentView!.addSubview(GradientTop())
        contentView!.addSubview(Progress.shared)
        contentView!.addSubview(Search.shared)
        /*
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
         */
        contentView!.layoutSubtreeIfNeeded()
        
        
        
        Repository.shared.select = { board in DispatchQueue.main.async { self.select(board) } }
        Repository.shared.error = { Alert.shared.add($0) }
        Skin.add(self, selector:#selector(updateSkin))
        DispatchQueue.main.async {
            self.updateSkin()
            List.shared.toggle()
            DispatchQueue.global(qos:.background).async {
                Repository.shared.load()
                Skin.update(Repository.shared.account)
            }
        }
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
