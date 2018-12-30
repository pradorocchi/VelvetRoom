import UIKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.font = .light(14)
        text.text = card.content
        self.card = card
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textViewDidEndEditing(_ textView:UITextView) {
        if card.content.isEmpty {
            UIApplication.shared.keyWindow!.endEditing(true)
            Application.view.delete(self)
        } else {
            card.content = text.text
            super.textViewDidEndEditing(textView)
        }
    }
    
    override func beginDrag() {
        super.beginDrag()
//        Application.shared.view.beginDrag(self)
    }
    
    override func endDrag() {
        super.endDrag()
//        Application.shared.view.endDrag(self)
    }
}
