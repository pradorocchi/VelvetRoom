import AppKit
import VelvetRoom

class View:NSWindow {
    private weak var boards:NSScrollView!
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
        let boards = NSScrollView()
        boards.drawsBackground = false
        boards.translatesAutoresizingMaskIntoConstraints = false
        boards.hasVerticalScroller = true
        boards.verticalScroller!.controlSize = .mini
        boards.documentView = DocumentView()
        (boards.documentView! as! DocumentView).autoLayout()
        contentView!.addSubview(boards)
        self.boards = boards
        
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
    }
    
    private func list(_ boards:[Board]) {
        self.boards.documentView!.subviews.forEach { $0.removeFromSuperview() }
        var top = self.boards.documentView!.topAnchor
        boards.forEach { board in
            let view = BoardView(board)
            view.target = self
            view.action = #selector(select(board:))
            self.boards.documentView!.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top).isActive = true
            view.leftAnchor.constraint(equalTo:self.boards.leftAnchor, constant:1).isActive = true
            view.rightAnchor.constraint(equalTo:self.boards.rightAnchor).isActive = true
            top = view.bottomAnchor
        }
        self.boards.documentView!.bottomAnchor.constraint(equalTo:top).isActive = true
    }
    
    private func select(_ board:Board) {
        print("select: \(board)")
    }
    
    @objc private func select(board:BoardView) {
        presenter.selected = board
    }
    
    @IBAction private func newDocument(_ sender:Any) {
        Application.view.beginSheet(NewBoardView(presenter))
    }
}
