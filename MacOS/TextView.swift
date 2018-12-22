import AppKit

class TextView:NSTextView {
    static let lineHeight:CGFloat = 24
    
    init() {
        let container = NSTextContainer()
        let storage = NSTextStorage()
        let layout = NSLayoutManager()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        isContinuousSpellCheckingEnabled = true
        allowsUndo = true
        drawsBackground = false
        usesFindBar = true
        isIncrementalSearchingEnabled = true
        isRichText = false
        isEditable = false
        insertionPointColor = .velvetBlue
        font = .regular(14)
        textContainer!.lineFragmentPadding = 0
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn:Bool) {
        var rect = rect
//        rect.size.width = 4
        super.drawInsertionPoint(in:rect, color:color, turnedOn:turnedOn)
    }
    
    override func mouseDown(with event: NSEvent) {
        if !isEditable {
            superview?.mouseDown(with:event)
        } else {
            super.mouseDown(with:event)
        }
    }
}
