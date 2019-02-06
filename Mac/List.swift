import AppKit

class List:ScrollView {
    static let shared = List()
    private(set) var visible = false
    
    private weak var left:NSLayoutConstraint!
    
    private override init() {
        super.init()
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
}
