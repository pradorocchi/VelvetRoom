import AppKit
import VelvetRoom

class View:NSWindow {
    private weak var boards:ScrollView!
    private weak var columns:ScrollView!
    private let presenter = Presenter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .textBackgroundColor
        makeOutlets()
        presenter.list = { self.list($0) }
        presenter.select = { self.select($0) }
        presenter.load()
    }
    
    private func makeOutlets() {
        let boards = ScrollView()
        boards.hasVerticalScroller = true
        boards.verticalScroller!.controlSize = .mini
        contentView!.addSubview(boards)
        self.boards = boards
        
        let columns = ScrollView()
        columns.hasVerticalScroller = true
        columns.hasHorizontalScroller = true
        columns.verticalScroller!.controlSize = .mini
        columns.horizontalScroller!.controlSize = .mini
        contentView!.addSubview(columns)
        self.columns = columns
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        contentView!.addSubview(border)
        
        boards.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:36).isActive = true
        boards.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        boards.rightAnchor.constraint(equalTo:border.leftAnchor).isActive = true
        boards.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-2).isActive = true
        
        border.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:1).isActive = true
        border.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:1).isActive = true
        border.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:200).isActive = true
        border.widthAnchor.constraint(equalToConstant:1).isActive = true
        
        columns.topAnchor.constraint(equalTo:boards.topAnchor).isActive = true
        columns.leftAnchor.constraint(equalTo:border.rightAnchor).isActive = true
        columns.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
        columns.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-2).isActive = true
    }
    
    private func list(_ boards:[Board]) {
        self.boards.removeSubviews()
        var top = self.boards.documentView!.topAnchor
        boards.forEach { board in
            let view = BoardView(board)
            view.target = self
            view.action = #selector(select(view:))
            self.boards.documentView!.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top).isActive = true
            view.leftAnchor.constraint(equalTo:self.boards.leftAnchor, constant:1).isActive = true
            view.rightAnchor.constraint(equalTo:self.boards.rightAnchor).isActive = true
            top = view.bottomAnchor
        }
        self.boards.bottom = self.boards.documentView!.bottomAnchor.constraint(equalTo:top)
    }
    
    private func render(_ columns:[Column]) {
        self.columns.removeSubviews()
        self.columns.bottom = nil
        var left = self.columns.documentView!.leftAnchor
        for (index, column) in columns.enumerated() {
            let view = ColumnView(column, index:index)
            self.columns.documentView!.addSubview(view)
            
            view.topAnchor.constraint(equalTo:self.columns.documentView!.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo:left).isActive = true
            left = view.rightAnchor
            self.columns.documentView!.bottomAnchor.constraint(greaterThanOrEqualTo:view.bottomAnchor)
        }
        self.columns.right = self.columns.documentView!.rightAnchor.constraint(equalTo:left)
    }
    
    private func select(_ board:Board) {
        let view = boards.documentView!.subviews.first { ($0 as! BoardView).board.id == board.id } as! BoardView
        select(view:view)
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                context.allowsImplicitAnimation = true
                self.boards.contentView.scrollToVisible(view.frame)
            }
        }
    }
    
    @objc private func select(view:BoardView) {
        presenter.selected = view
        render(view.board.columns)
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        Application.view.beginSheet(NewBoardView(presenter))
    }
}
