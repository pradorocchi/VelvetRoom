import AppKit
import VelvetRoom

class View:NSWindow {
    let presenter = Presenter()
    private weak var list:ScrollView!
    private weak var canvas:ScrollView!
    private weak var root:ItemView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .textBackgroundColor
        makeOutlets()
        presenter.list = { self.list($0) }
        presenter.select = { self.select($0) }
        presenter.load()
    }
    
    func contentChanged() {
        canvas.documentView!.layoutSubtreeIfNeeded()
        align()
        presenter.scheduleUpdate()
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                context.allowsImplicitAnimation = true
                canvas.documentView!.layoutSubtreeIfNeeded()
            }
        }
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
        border.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:148).isActive = true
        border.widthAnchor.constraint(equalToConstant:1).isActive = true
        
        canvas.topAnchor.constraint(equalTo:list.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo:border.rightAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-2).isActive = true
    }
    
    private func list(_ boards:[Board]) {
        list.removeSubviews()
        var top = list.documentView!.topAnchor
        boards.forEach { board in
            let view = BoardView(board, presenter:presenter)
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
        board.columns.enumerated().forEach {
            let column = ColumnView($0.element, index:$0.offset, view:self)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            canvas.documentView!.addSubview(column)
            var child:ItemView = column
            
            if $0.offset == 0 {
                let buttonCard = NewItemView(self, selector:#selector(newCard))
                canvas.documentView!.addSubview(buttonCard)
                child.child = buttonCard
            }
            sibling = column
        }
        
        let buttonColumn = NewItemView(self, selector:#selector(newColumn))
        canvas.documentView!.addSubview(buttonColumn)
        
        if root == nil {
            root = buttonColumn
        } else {
            sibling!.sibling = buttonColumn
        }
    }
    
    private func align() {
        var maxRight = CGFloat(40)
        var maxBottom = CGFloat()
        var sibling = root
        while sibling != nil {
            let right = maxRight
            var bottom = CGFloat()
            
            var child = sibling
            while child != nil {
                child!.left.constant = right
                child!.top.constant = bottom
                
                bottom += child!.bounds.height + 40
                maxRight = max(maxRight, right + child!.bounds.width + 40)
                
                child = child!.child
            }
            
            maxBottom = max(bottom, maxBottom)
            sibling = sibling!.sibling
        }
        canvas.bottom = canvas.documentView!.heightAnchor.constraint(equalToConstant:maxBottom)
        canvas.right = canvas.documentView!.widthAnchor.constraint(equalToConstant:maxRight)
    }
    
    private func buttonNew(_ selector:Selector) -> NSButton {
        let button = NSButton()
        button.isBordered = false
        button.image = NSImage(named:"new")
        button.target = self
        button.action = selector
        button.imageScaling = .scaleNone
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setButtonType(.momentaryChange)
        button.widthAnchor.constraint(equalToConstant:24).isActive = true
        button.heightAnchor.constraint(equalToConstant:18).isActive = true
        return button
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
        Application.view.makeFirstResponder(nil)
        presenter.selected = view
        render(view.board)
        canvas.documentView!.layoutSubtreeIfNeeded()
        align()
    }
    
    @objc private func newColumn() {
        print("new column")
    }
    
    @objc private func newCard() {
        print("new card")
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        Application.view.makeFirstResponder(nil)
        Application.view.beginSheet(NewBoardView(presenter))
    }
}
