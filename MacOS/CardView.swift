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
        
        let content = TextView(card.content, maxWidth:220, maxHeight:1000000)
        content.font = .regular(14)
        content.delegate = self
        addSubview(content)
        self.content = content
        
        content.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        content.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        content.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        content.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    override func cancelOperation(_:Any?) { Application.view.makeFirstResponder(nil) }
    
    func beginEditing() {
        content.isEditable = true
        Application.view.makeFirstResponder(content)
    }
    
    func textDidChange(_:Notification) {
        view.canvasChanged()
    }
    
    func textDidEndEditing(_ notification:Notification) {
        card.content = content.string
    }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            beginEditing()
        }
    }
}
