import AppKit

class ItemView:NSControl {
    weak var left:NSLayoutConstraint! { didSet { left.isActive = true } }
    weak var top:NSLayoutConstraint! { didSet { top.isActive = true } }
    weak var sibling:ItemView?
    weak var child:ItemView?
    
    init() { super.init(frame:.zero) }
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if let superview = superview {
            left = leftAnchor.constraint(equalTo:superview.leftAnchor)
            top = topAnchor.constraint(equalTo:superview.topAnchor)
        }
    }
}
