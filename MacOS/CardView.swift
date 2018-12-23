import AppKit
import VelvetRoom

class CardView:ItemView, NSTextViewDelegate {
    private(set) weak var card:Card!
    private weak var content:TextView!
    private weak var view:View!
    
    init(_ card:Card, view:View) {
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.card = card
        self.view = view
        
        let content = TextView(card.content)
        content.delegate = self
        addSubview(content)
        self.content = content
        
        content.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        content.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        content.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
    }
    
    func textDidChange(_:Notification) {
        card.content = content.string
        view.canvasChanged()
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            content.isEditable = true
            Application.view.makeFirstResponder(content)
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
}
