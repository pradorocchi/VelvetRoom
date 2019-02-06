import AppKit
import VelvetRoom

class List:ScrollView {
    static let shared = List()
    var current:BoardView? { return documentView!.subviews.first(where:{ ($0 as! BoardView).selected }) as? BoardView }
    private(set) var visible = false
    private weak var left:NSLayoutConstraint!
    
    private override init() {
        super.init()
        Repository.shared.list = { boards in DispatchQueue.main.async { self.render(boards) } }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func scheduleUpdate(_ board:Board? = nil) {
        DispatchQueue.global(qos:.background).async {
            if let board = board ?? self.current?.board {
                Repository.shared.scheduleUpdate(board)
            }
        }
    }
    
    @objc func toggle() {
        visible.toggle()
        if visible {
            Toolbar.shared.list.state = .on
            left.constant = 0
            Menu.shared.list.title = .local("List.hide")
        } else {
            Toolbar.shared.list.state = .on
            left.constant = -280
            Menu.shared.list.title = .local("List.show")
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            superview!.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    private func render(_ boards:[Board]) {
        current?.selected = false
        Repository.shared.fire
        Toolbar.shared.extended = false
        Menu.shared.extended = false
        Progress.shared.chart = []
        Canvas.shared.removeSubviews()
        List.shared.removeSubviews()
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
}
