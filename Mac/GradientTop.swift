import AppKit

class GradientTop:NSView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer = CAGradientLayer()
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = [0, 1]
        wantsLayer = true
        updateSkin()
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        topAnchor.constraint(equalTo:superview!.topAnchor).isActive = true
        leftAnchor.constraint(equalTo:superview!.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo:superview!.rightAnchor).isActive = true
        heightAnchor.constraint(equalToConstant:72).isActive = true
    }
    
    @objc private func updateSkin() {
        (layer as! CAGradientLayer).colors = [Skin.shared.background.withAlphaComponent(0).cgColor,
                                              Skin.shared.background.cgColor]
    }
}
