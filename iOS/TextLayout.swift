import UIKit

class TextLayout:NSLayoutManager, NSLayoutManagerDelegate {
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func layoutManager(_:NSLayoutManager, shouldSetLineFragmentRect rect:UnsafeMutablePointer<CGRect>,
                       lineFragmentUsedRect:UnsafeMutablePointer<CGRect>, baselineOffset
        base:UnsafeMutablePointer<CGFloat>, in:NSTextContainer, forGlyphRange:NSRange) -> Bool {
        base.pointee = base.pointee + ((22 - rect.pointee.size.height) / 2)
        rect.pointee.size.height = 22
        lineFragmentUsedRect.pointee.size.height = 22
        return true
    }
    
    override func setExtraLineFragmentRect(_ rect:CGRect, usedRect:CGRect, textContainer container:NSTextContainer) {
        var rect = rect
        var used = usedRect
        rect.size.height = 22
        used.size.height = 22
        super.setExtraLineFragmentRect(rect, usedRect:used, textContainer:container)
    }
}
