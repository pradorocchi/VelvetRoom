import AppKit

class TextLayout:NSLayoutManager, NSLayoutManagerDelegate {
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func layoutManager(_:NSLayoutManager, shouldSetLineFragmentRect rect:UnsafeMutablePointer<NSRect>,
                       lineFragmentUsedRect:UnsafeMutablePointer<NSRect>, baselineOffset
        base:UnsafeMutablePointer<CGFloat>, in:NSTextContainer, forGlyphRange:NSRange) -> Bool {
        base.pointee = base.pointee + ((TextView.lineHeight - rect.pointee.size.height) / 2)
        rect.pointee.size.height = TextView.lineHeight
        lineFragmentUsedRect.pointee.size.height = TextView.lineHeight
        return true
    }
    
    override func setExtraLineFragmentRect(_ rect:NSRect, usedRect:NSRect, textContainer container:NSTextContainer) {
        var rect = rect
        var used = usedRect
        rect.size.height = TextView.lineHeight
        used.size.height = TextView.lineHeight
        super.setExtraLineFragmentRect(rect, usedRect:used, textContainer:container)
    }
}
