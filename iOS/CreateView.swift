import UIKit

class CreateView:ItemView {
    init(_ selector:Selector) {
        super.init()
        widthAnchor.constraint(equalToConstant:64).isActive = true
        heightAnchor.constraint(equalToConstant:40).isActive = true
        
        let image = UIImageView(image:#imageLiteral(resourceName: "new.pdf"))
        image.isUserInteractionEnabled = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
//        action = selector
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
//    override func mouseDown(with:NSEvent) {
//        sendAction(action, to:Application.shared.view)
//        if #available(OSX 10.12, *) {
//            NSAnimationContext.runAnimationGroup( { context in
//                context.duration = 0.2
//                context.allowsImplicitAnimation = true
//                alphaValue = 0.2
//            } ) {
//                self.alphaValue = 1
//            }
//        }
//    }
}
