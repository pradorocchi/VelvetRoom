import UIKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
//        text.textContainer!.size = NSSize(width:400, height:1000000)
        text.font = .light(14)
//        text.string = card.content
//        text.update()
        self.card = card
    }
    
    required init?(coder:NSCoder) { return nil }
    
//    override func textDidEndEditing(_ notification:Notification) {
//        card.content = text.string
//        super.textDidEndEditing(notification)
//        if card.content.isEmpty {
//            Application.shared.view.delete(self)
//        }
//    }
    
    override func beginDrag() {
        super.beginDrag()
//        Application.shared.view.beginDrag(self)
    }
    
    override func endDrag() {
        super.endDrag()
//        Application.shared.view.endDrag(self)
    }
}
