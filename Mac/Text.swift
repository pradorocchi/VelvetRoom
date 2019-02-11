import AppKit

class Text:NSTextView {
    private weak var width:NSLayoutConstraint!
    private weak var height:NSLayoutConstraint!
    override var string:String { didSet { adjustConstraints() } }
    override var font:NSFont? {
        didSet {
            let storage = textStorage as! Storage
            storage.text = font
            storage.header = .bold(font!.pointSize)
        }
    }
    
    init() {
        let container = NSTextContainer()
        let storage = Storage()
        let layout = Layout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        container.lineBreakMode = .byTruncatingHead
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        isContinuousSpellCheckingEnabled = true
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        isEditable = false
        isSelectable = false
        insertionPointColor = .velvetBlue
        width = widthAnchor.constraint(equalToConstant:0)
        height = heightAnchor.constraint(equalToConstant:0)
        width.isActive = true
        height.isActive = true
        adjustConstraints()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn:Bool) {
        var rect = rect
        rect.size.width += 4
        super.drawInsertionPoint(in:rect, color:color, turnedOn:turnedOn)
    }
    
    override func mouseDown(with:NSEvent) {
        if !isEditable {
            superview?.mouseDown(with:with)
        } else {
            super.mouseDown(with:with)
        }
    }
    
    override func didChangeText() {
        super.didChangeText()
        adjustConstraints()
    }
    
    override func resignFirstResponder() -> Bool {
        isEditable = false
        isSelectable = false
        setSelectedRange(NSMakeRange(string.count, 0))
        return super.resignFirstResponder()
    }
    
    private func adjustConstraints() {
        layoutManager!.ensureLayout(for:textContainer!)
        let size = layoutManager!.usedRect(for:textContainer!).size
        width.constant = size.width + 4
        height.constant = size.height
    }
}
