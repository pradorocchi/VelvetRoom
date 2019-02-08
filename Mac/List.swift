import AppKit
import VelvetRoom

class List:Scroll {
    static let shared = List()
    weak var left:NSLayoutConstraint! { didSet { left.isActive = true } }
    var current:BoardView? { return documentView!.subviews.first(where:{ ($0 as! BoardView).selected }) as? BoardView }
    private weak var bottom:NSLayoutConstraint? { willSet { bottom?.isActive = false; newValue?.isActive = true } }
    private(set) var visible = false
    
    private override init() {
        super.init()
        Repository.shared.list = { boards in DispatchQueue.main.async { self.render(boards) } }
        Repository.shared.select = { board in DispatchQueue.main.async { self.select(board) } }
        documentView!.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func scheduleUpdate(_ board:Board? = nil) {
        DispatchQueue.main.async {
            if let board = board ?? self.current?.board {
                DispatchQueue.global(qos:.background).async {
                    Repository.shared.scheduleUpdate(board)
                }
            }
        }
    }
    
    func select(_ board:Board) {
        let view = documentView!.subviews.first(where:{ ($0 as! BoardView).board === board }) as! BoardView
        makeCurrent(view)
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                context.allowsImplicitAnimation = true
                self.contentView.scrollToVisible(view.frame)
            }, completionHandler:nil)
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
        if !boards.isEmpty {
            Window.shared.splash?.remove()
        }
        current?.selected = false
        Repository.shared.fireSchedule()
        Toolbar.shared.extended = false
        Menu.shared.extended = false
        Progress.shared.update()
        Canvas.shared.removeSubviews()
        List.shared.removeSubviews()
        var top = documentView!.topAnchor
        boards.enumerated().forEach {
            let view = BoardView($0.element)
            view.selector = #selector(makeCurrent(_:))
            documentView!.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top, constant:$0.offset == 0 ? 36 : 0).isActive = true
            view.leftAnchor.constraint(equalTo:leftAnchor, constant:-8).isActive = true
            view.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
            top = view.bottomAnchor
        }
        bottom = documentView!.bottomAnchor.constraint(equalTo:top, constant:20)
    }
    
    @objc private func makeCurrent(_ view:BoardView) {
        Window.shared.makeFirstResponder(nil)
        Repository.shared.fireSchedule()
        current?.selected = false
        view.selected = true
        Canvas.shared.display(view.board)
        Toolbar.shared.extended = true
        Menu.shared.extended = true
        Progress.shared.update()
    }
}
