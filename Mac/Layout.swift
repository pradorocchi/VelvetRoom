import AppKit

class Layout:NSLayoutManager, NSLayoutManagerDelegate {
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func layoutManager(_:NSLayoutManager, shouldSetLineFragmentRect rect:UnsafeMutablePointer<NSRect>,
                       lineFragmentUsedRect:UnsafeMutablePointer<NSRect>, baselineOffset
        base:UnsafeMutablePointer<CGFloat>, in:NSTextContainer, forGlyphRange:NSRange) -> Bool {
        base.pointee = base.pointee + 5
        rect.pointee.size.height += 10
        lineFragmentUsedRect.pointee.size.height += 10
        return true
    }
    
    override func setExtraLineFragmentRect(_ rect:NSRect, usedRect:NSRect, textContainer container:NSTextContainer) {
        var rect = rect
        var used = usedRect
        rect.size.height += 10
        used.size.height += 10
        super.setExtraLineFragmentRect(rect, usedRect:used, textContainer:container)
    }
}
