import AppKit

class ProgressView:NSView {
    private weak var marker:NSLayoutXAxisAnchor!
    private var views = [NSView]()
    private var widths = [NSLayoutConstraint]()
    var chart = [(String, Float)]() { didSet {
        let items = chart.compactMap({ $0.1 > 0 ? $0.1 : nil })
        while items.count < views.count { views.removeLast().removeFromSuperview() }
        while items.count > views.count {
            let view = NSView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.wantsLayer = true
            addSubview(view)
            view.topAnchor.constraint(equalTo:topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
            view.leftAnchor.constraint(
                equalTo:views.isEmpty ? marker : views.last!.rightAnchor, constant:2).isActive = true
            views.append(view)
        }
        updateSkin()
        layoutSubtreeIfNeeded()
        widths.forEach({ $0.isActive = false })
        items.enumerated().forEach {
            widths.append(views[$0.offset].widthAnchor.constraint(equalTo:widthAnchor, multiplier:CGFloat($0.element)))
            widths.last!.isActive = true
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    } }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 2
        heightAnchor.constraint(equalToConstant:18).isActive = true
        
        let marker = NSView()
        marker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(marker)
        marker.leftAnchor.constraint(equalTo:leftAnchor, constant:-2).isActive = true
        self.marker = marker.leftAnchor
        
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    @objc private func updateSkin() {
        views.forEach {
            $0.layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.2).cgColor
        }
    }
}
