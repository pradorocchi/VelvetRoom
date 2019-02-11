import UIKit

class Button:UIButton {
    init(_ image:UIImage, target:Any, selector:Selector) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(target, action:selector, for:.touchUpInside)
        setImage(#imageLiteral(resourceName: "import.pdf"), for:.normal)
        imageView!.clipsToBounds = true
        imageView!.contentMode = .center
        heightAnchor.constraint(equalToConstant:50).isActive = true
        widthAnchor.constraint(equalToConstant:64).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
