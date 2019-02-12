import AppKit

class Progress:NSView {
    static let shared = Progress()
    private weak var marker:NSLayoutXAxisAnchor!
    private var views = [NSView]()
    private var widths = [NSLayoutConstraint]()
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 2
        
        let marker = NSView()
        marker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(marker)
        marker.leftAnchor.constraint(equalTo:leftAnchor, constant:-2).isActive = true
        self.marker = marker.leftAnchor
        
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update() {
        guard let items = List.shared.selected?.board.chart.compactMap({ $0.1 > 0 ? $0.1 : nil }) else { return }
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
        widths = []
        items.enumerated().forEach {
            widths.append(views[$0.offset].widthAnchor.constraint(equalTo:widthAnchor, multiplier:CGFloat($0.element)))
            widths.last!.isActive = true
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    @objc private func updateSkin() {
        views.forEach { $0.layer!.backgroundColor = Skin.shared.text.withAlphaComponent(0.2).cgColor }
    }
}
