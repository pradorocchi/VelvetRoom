import AppKit

class ItemView:NSView {
    weak var sibling:ItemView?
    weak var child:ItemView?
    private(set) weak var left:NSLayoutConstraint!
    private(set) weak var top:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if let superview = superview {
            left = leftAnchor.constraint(equalTo:superview.leftAnchor)
            top = topAnchor.constraint(equalTo:superview.topAnchor)
            left.isActive = true
            top.isActive = true
        }
    }
}
