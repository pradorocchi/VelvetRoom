import AppKit

class ProgressView:NSView {
    var chart = [(String, Float)]() { didSet {
        subviews.forEach { $0.removeFromSuperview() }
        animate(chart.map { $0.1 }, left:leftAnchor)
    } }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.clear.cgColor
        layer!.cornerRadius = 2
        heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func animate(_ chart:[Float], left:NSLayoutXAxisAnchor) {
        guard let current = chart.first else { return }
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        if chart.count == 1 {
            view.layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.3).cgColor
        } else {
            view.layer!.backgroundColor = Application.skin.text.withAlphaComponent(0.2).cgColor
        }
        addSubview(view)
        
        view.topAnchor.constraint(equalTo:topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo:left, constant:1).isActive = true
        view.layoutSubtreeIfNeeded()
        view.widthAnchor.constraint(equalTo:widthAnchor, multiplier:CGFloat(current)).isActive = true
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }) { [weak self] in self?.animate(Array(chart.dropFirst()), left:view.rightAnchor) }
    }
}
