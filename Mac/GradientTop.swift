import AppKit

class GradientTop:NSView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer = CAGradientLayer()
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = [0, 1]
        (layer as! CAGradientLayer).colors = [NSColor.clear.cgColor, NSColor.clear.cgColor]
        wantsLayer = true
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func updateSkin() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            (layer as! CAGradientLayer).colors = [Skin.shared.background.withAlphaComponent(0).cgColor,
                                                  Skin.shared.background.cgColor]
        }, completionHandler:nil)
    }
}
