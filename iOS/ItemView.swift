import UIKit

class ItemView:UIControl {
    weak var sibling:ItemView?
    weak var child:ItemView?
    private(set) weak var left:NSLayoutConstraint! { didSet { left.isActive = true } }
    private(set) weak var top:NSLayoutConstraint! { didSet { top.isActive = true } }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            left = leftAnchor.constraint(equalTo:superview.leftAnchor)
            top = topAnchor.constraint(equalTo:superview.topAnchor)
        }
    }
}
