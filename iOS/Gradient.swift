import UIKit

class Gradient:UIView {
    override class var layerClass:AnyClass { return CAGradientLayer.self }
    
    init(_ locations:[NSNumber]) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = locations
        (layer as! CAGradientLayer).colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func updateSkin() {
        UIView.animate(withDuration:1) {
            (self.layer as! CAGradientLayer).colors = [Skin.shared.background.withAlphaComponent(0.95).cgColor,
                                                       Skin.shared.background.withAlphaComponent(0).cgColor]
        }
    }
}