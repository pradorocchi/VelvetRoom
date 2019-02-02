import UIKit

class GradientView:UIView {
    override class var layerClass:AnyClass { return CAGradientLayer.self }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = [0, 1]
        updateSkin()
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    @objc private func updateSkin() {
        (layer as! CAGradientLayer).colors = [Application.skin.background.withAlphaComponent(0.95).cgColor,
                                              Application.skin.background.withAlphaComponent(0).cgColor]
    }
}
