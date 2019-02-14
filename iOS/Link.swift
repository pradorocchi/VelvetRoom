import UIKit

class Link:UIButton {
    init(_ title:String, target:Any, selector:Selector) {
        super.init(frame:.zero)
        layer.cornerRadius = 4
        backgroundColor = .velvetBlue
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action:selector, for:.touchUpInside)
        setTitle(title, for:[])
        setTitleColor(.black, for:.normal)
        setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        
        widthAnchor.constraint(equalToConstant:88).isActive = true
        heightAnchor.constraint(equalToConstant:30).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
