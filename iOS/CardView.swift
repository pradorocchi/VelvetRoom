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
        detach()
    }
    
    override func endDrag() {
        super.endDrag()
        var column = Application.view.root
        while column!.sibling is ColumnView {
            guard column!.sibling!.left.constant < frame.midX else { break }
            column = column!.sibling
        }
        var after = column
        while after!.child != nil {
            guard after!.child!.top.constant < top.constant else { break }
            after = after!.child
        }
        if after!.child is CreateView {
            after = after?.child
        }
        child = after!.child
        after!.child = self
        Application.view.canvasChanged()
        Application.view.repository.move(card, board:Application.view.selected, column:(column as! ColumnView).column,
                                         after:(after as? CardView)?.card)
        Application.view.scheduleUpdate()
        Application.view.progressButton.progress = Application.view.selected.progress
    }
    
    private func confirmDelete() {
        detach()
        DispatchQueue.global(qos:.background).async {
            Application.view.repository.delete(self.card, board:Application.view.selected)
            Application.view.scheduleUpdate()
            DispatchQueue.main.async {
                Application.view.progressButton.progress = Application.view.selected.progress
                self.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if let parent = Application.view.canvas.subviews.first(where:
            { ($0 as! ItemView).child === self } ) as? ItemView {
            parent.child = child
            Application.view.canvasChanged()
        }
    }
}
