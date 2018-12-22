import AppKit
import VelvetRoom

class CardView:ItemView, NSTextViewDelegate {
    private(set) weak var card:Card!
    private weak var content:NSTextView!
    private weak var contentWidth:NSLayoutConstraint!
    private weak var contentHeight:NSLayoutConstraint!
    private weak var view:View!
    
    init(_ card:Card, view:View) {
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.card = card
        self.view = view
        
        let content = NSTextView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.isContinuousSpellCheckingEnabled = true
        content.allowsUndo = true
        content.drawsBackground = false
        content.isIncrementalSearchingEnabled = true
        content.isRichText = false
        content.insertionPointColor = .velvetBlue
        content.font = .regular(14)
        content.delegate = self
        content.string = card.content
        content.textContainer!.lineFragmentPadding = 0
        addSubview(content)
        self.content = content
        /*
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.drawsBackground = false
        name.isBezeled = false
        name.isEditable = false
        name.focusRingType = .none
        name.font = .regular(14)
        name.stringValue = "hello world"//;card.content.last?.value ?? String()
        name.maximumNumberOfLines = 1
        name.lineBreakMode = .byTruncatingTail
        name.delegate = self
        addSubview(name)
        self.name = name
        
        name.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        name.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        nameWidth = name.widthAnchor.constraint(greaterThanOrEqualToConstant:0)
        nameWidth.isActive = true
        
        updateWidth()*/
        
        content.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        content.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        content.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        contentWidth = content.widthAnchor.constraint(equalToConstant:0)
        contentHeight = content.heightAnchor.constraint(equalToConstant:0)
        contentWidth.isActive = true
        contentHeight.isActive = true
        updateSize()
    }
    
    func textDidChange(_:Notification) {
        card.content = content.string
        updateSize()
        view.canvasChanged()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
//            name.isEditable = true
//            Application.view.makeFirstResponder(name)
//            name.currentEditor()?.selectedRange = NSMakeRange(name.stringValue.count, 0)
        }
    }
    
    func controlTextDidEndEditing(_:Notification) {
//        name.isEditable = false
//        column.name = name.stringValue
//        updateWidth()
        view.canvasChanged()
    }
    
    func control(_:NSControl, textView:NSTextView, doCommandBy selector:Selector) -> Bool {
        if (selector == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    private func updateSize() {
        let size = content.textStorage!.boundingRect(with:NSSize(width:220, height:10000), options:
            [.usesLineFragmentOrigin, .usesFontLeading])
        contentWidth.constant = ceil(size.width)
        contentHeight.constant = ceil(size.height)
    }
}
