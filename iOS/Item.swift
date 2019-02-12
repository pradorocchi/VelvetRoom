import UIKit

class Item:UIControl {
    weak var sibling:Item?
    weak var child:Item?
    private(set) weak var left:NSLayoutConstraint!
    private(set) weak var top:NSLayoutConstraint!
    
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
            left.isActive = true
            top.isActive = true
        }
    }
}
