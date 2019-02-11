import AppKit

class GradientLeft:NSView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer = CAGradientLayer()
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0, y:0.5)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:1, y:0.5)
        (layer as! CAGradientLayer).locations = [0, 0.7, 1]
        (layer as! CAGradientLayer).colors = [NSColor.clear.cgColor, NSColor.clear.cgColor, NSColor.clear.cgColor]
        wantsLayer = true
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func updateSkin() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            (layer as! CAGradientLayer).colors = [Skin.shared.background.cgColor,
                                                  Skin.shared.background.withAlphaComponent(0.95).cgColor,
                                                  Skin.shared.background.withAlphaComponent(0).cgColor]
        }, completionHandler:nil)
    }
}
