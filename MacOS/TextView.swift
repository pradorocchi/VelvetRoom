import AppKit

class TextView:NSTextView {
    override func mouseDown(with event: NSEvent) {
        if !isEditable {
            superview?.mouseDown(with:event)
        } else {
            super.mouseDown(with:event)
        }
    }
}
