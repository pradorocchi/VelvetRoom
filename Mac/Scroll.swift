import AppKit

class Scroll:NSScrollView {
    init() {
        super.init(frame:.zero)
        drawsBackground = false
        translatesAutoresizingMaskIntoConstraints = false
        documentView = FlippedView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo:topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func removeSubviews() {
        documentView!.subviews.forEach { $0.removeFromSuperview() }
    }
}

private class FlippedView:NSView {
    override var isFlipped:Bool { return true }
}
