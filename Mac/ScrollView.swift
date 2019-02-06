import AppKit

class ScrollView:NSScrollView {
    weak var right:NSLayoutConstraint? { willSet { right?.isActive = false } didSet { right?.isActive = true } }
    weak var bottom:NSLayoutConstraint? { willSet { bottom?.isActive = false } didSet { bottom?.isActive = true } }
    
    init() {
        super.init(frame:.zero)
        drawsBackground = false
        translatesAutoresizingMaskIntoConstraints = false
        documentView = FlippedView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo:topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        defer {
            bottom = documentView!.bottomAnchor.constraint(equalTo:bottomAnchor)
            right = documentView!.rightAnchor.constraint(equalTo:rightAnchor)
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func removeSubviews() {
        documentView!.subviews.forEach { $0.removeFromSuperview() }
    }
}

private class FlippedView:NSView {
    override var isFlipped:Bool { return true }
}
