import AppKit

class GradientLeft:NSView {
    init() {
        super.init(frame:.zero)
        alphaValue = 0
        translatesAutoresizingMaskIntoConstraints = false
        layer = CAGradientLayer()
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = [0, 1]
        wantsLayer = true
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func updateSkin() {
        (layer as! CAGradientLayer).colors = [Skin.shared.background.cgColor,
                                              Skin.shared.background.withAlphaComponent(0.9).cgColor,
                                              Skin.shared.background.withAlphaComponent(0).cgColor]
    }
}
