import UIKit

class GradientTop:UIView {
    override class var layerClass:AnyClass { return CAGradientLayer.self }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = [0, 0.75, 1]
        (layer as! CAGradientLayer).colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        heightAnchor.constraint(equalToConstant:70).isActive = true
        Skin.add(self)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func updateSkin() {
        UIView.animate(withDuration:1) {
            (self.layer as! CAGradientLayer).colors = [Skin.shared.background.withAlphaComponent(0.95).cgColor,
                                                       Skin.shared.background.withAlphaComponent(0.6).cgColor,
                                                       Skin.shared.background.withAlphaComponent(0).cgColor]
        }
    }
}
