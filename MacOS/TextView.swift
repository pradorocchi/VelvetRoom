import AppKit

class TextView:NSTextView {
    private weak var width:NSLayoutConstraint!
    private weak var height:NSLayoutConstraint!
    override var font:NSFont? { didSet { didChangeText() } }
    
    init(_ string:String, maxWidth:CGFloat, maxHeight:CGFloat) {
        let container = NSTextContainer()
        let storage = NSTextStorage()
        let layout = TextLayout()
        container.size = NSSize(width:maxWidth, height:maxHeight)
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        isContinuousSpellCheckingEnabled = true
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        isEditable = false
        insertionPointColor = .velvetBlue
        self.string = string
        
        width = widthAnchor.constraint(equalToConstant:0)
        height = heightAnchor.constraint(equalToConstant:0)
        width.isActive = true
        height.isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn:Bool) {
        var rect = rect
        rect.size.width += 4
        super.drawInsertionPoint(in:rect, color:color, turnedOn:turnedOn)
    }
    
    override func mouseDown(with event: NSEvent) {
        if !isEditable {
            superview?.mouseDown(with:event)
        } else {
            super.mouseDown(with:event)
        }
    }
    
    override func didChangeText() {
        super.didChangeText()
        layoutManager!.ensureLayout(for:textContainer!)
        let size = layoutManager!.usedRect(for:textContainer!).size
        width.constant = size.width + 4
        height.constant = size.height
    }
    
    override func resignFirstResponder() -> Bool {
        isEditable = false
        setSelectedRange(NSMakeRange(string.count, 0))
        return super.resignFirstResponder()
    }
}
