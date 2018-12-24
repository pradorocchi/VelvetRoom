import AppKit

class ItemView:NSControl {
    weak var sibling:ItemView?
    weak var child:ItemView?
    private(set) weak var left:NSLayoutConstraint! { didSet { left.isActive = true } }
    private(set) weak var top:NSLayoutConstraint! { didSet { top.isActive = true } }
    
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
        }
    }
}
