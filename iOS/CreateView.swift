import UIKit

class CreateView:ItemView {
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    
    init(_ selector:Selector) {
        super.init()
        widthAnchor.constraint(equalToConstant:70).isActive = true
        heightAnchor.constraint(equalToConstant:50).isActive = true
        addTarget(Application.view, action:selector, for:.touchUpInside)
        
        let image = UIImageView(image:#imageLiteral(resourceName: "new.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func update() {
        if isSelected || isHighlighted {
            alpha = 0.2
        } else {
            alpha = 1
        }
    }
}
