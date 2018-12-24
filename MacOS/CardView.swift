import AppKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card, view:View) {
        super.init(view)
        text.textContainer!.size = NSSize(width:220, height:1000000)
        text.font = .regular(14)
        text.string = card.content
        text.update()
        self.card = card
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textDidEndEditing(_ notification:Notification) {
        card.content = text.string
        super.textDidEndEditing(notification)
    }
}
