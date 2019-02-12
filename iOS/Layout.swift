import UIKit

class Layout:NSLayoutManager, NSLayoutManagerDelegate {
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func layoutManager(_:NSLayoutManager, shouldSetLineFragmentRect:UnsafeMutablePointer<CGRect>,
                       lineFragmentUsedRect:UnsafeMutablePointer<CGRect>, baselineOffset:UnsafeMutablePointer<CGFloat>,
                       in:NSTextContainer, forGlyphRange:NSRange) -> Bool {
        baselineOffset.pointee = baselineOffset.pointee + 5
        shouldSetLineFragmentRect.pointee.size.height += 10
        lineFragmentUsedRect.pointee.size.height += 10
        return true
    }
    
    override func setExtraLineFragmentRect(_ rect:CGRect, usedRect:CGRect, textContainer:NSTextContainer) {
        var rect = rect
        var used = usedRect
        rect.size.height += 10
        used.size.height += 10
        super.setExtraLineFragmentRect(rect, usedRect:used, textContainer:textContainer)
    }
}
