import UIKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.font = .light(14)
        text.text = card.content
        text.onDelete = {
            if !self.text.text.isEmpty {
                Application.view.present(DeleteView { self.confirmDelete() }, animated:true)
            }
        }
        self.card = card
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textViewDidEndEditing(_ textView:UITextView) {
        if text.text.isEmpty {
            UIApplication.shared.keyWindow!.endEditing(true)
            confirmDelete()
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
    
    private func confirmDelete() {
        Application.view.delete(self)
    }
}
