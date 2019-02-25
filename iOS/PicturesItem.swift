import UIKit
import Photos

class PicturesItem:UICollectionViewCell {
    private(set) weak var image:UIImageView!
    var request:PHImageRequestID?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        clipsToBounds = true
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        addSubview(image)
        self.image = image
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    private func update() { image.alpha = isSelected || isHighlighted ? 0.15 : 1 }
}
