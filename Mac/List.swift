import AppKit
import VelvetRoom

class List:NSScrollView {
    static let shared = List()
    weak var left:NSLayoutConstraint! { didSet { left.isActive = true } }
    weak var selected:BoardItem! { didSet { oldValue?.updateSkin(); selected?.updateSkin() } }
    private weak var bottom:NSLayoutConstraint? { willSet { bottom?.isActive = false; newValue?.isActive = true } }
    private(set) var visible = false
    
    private init() {
        super.init(frame:.zero)
        drawsBackground = false
        translatesAutoresizingMaskIntoConstraints = false
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo:topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        documentView!.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        Repository.shared.list = { boards in DispatchQueue.main.async { self.render([boards]) } }
        Repository.shared.select = { board in DispatchQueue.main.async {
            self.select(self.documentView!.subviews.first(where:{ ($0 as! BoardItem).board === board }) as! BoardItem) }
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
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
        selected = nil
        Toolbar.shared.extended = false
        Menu.shared.extended = false
        Repository.shared.fireSchedule()
        Progress.shared.update()
        Canvas.shared.documentView!.subviews.forEach { $0.removeFromSuperview() }
        documentView!.subviews.forEach { $0.removeFromSuperview() }
        var top = documentView!.topAnchor
        boards.enumerated().forEach {
            let item = BoardItem($0.element)
            item.selector = #selector(select(_:))
            documentView!.addSubview(item)
            item.topAnchor.constraint(equalTo:top, constant:$0.offset == 0 ? 36 : 0).isActive = true
            item.leftAnchor.constraint(equalTo:leftAnchor, constant:-8).isActive = true
            item.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
            top = item.bottomAnchor
        }
        bottom = documentView!.bottomAnchor.constraint(equalTo:top, constant:20)
    }
    
    @objc private func select(_ item:BoardItem) {
        Window.shared.makeFirstResponder(nil)
        Repository.shared.fireSchedule()
        selected = item
        Toolbar.shared.extended = true
        Menu.shared.extended = true
        Canvas.shared.display(item.board)
        Progress.shared.update()
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            contentView.scrollToVisible(CGRect(x:0, y:
                -documentView!.frame.height + item.frame.midY + (frame.height / 2), width:1, height:frame.height))
        }, completionHandler:nil)
    }
}
