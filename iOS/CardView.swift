import UIKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.font = .light(CGFloat(Repository.shared.account.font))
        text.text = card.content
        text.onDelete = { [weak self] in
            guard self?.text.text.isEmpty == false else { return }
//            Application.view.present(DeleteView { [weak self] in self?.confirmDelete() }, animated:true)
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
            text.text = card.content
        }
        super.textViewDidEndEditing(textView)
    }
    
    override func beginDrag() {
        super.beginDrag()
        detach()
    }
    
    override func endDrag() {
        var column = Canvas.shared.root
        while column!.sibling is ColumnView {
            guard column!.sibling!.left.constant < dragGesture.location(in:superview!).x else { break }
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
        Repository.shared.move(card, board:List.shared.selected.board, column:(column as! ColumnView).column,
                               after:(after as? CardView)?.card)
        super.endDrag()
    }
    
    private func confirmDelete() {
        detach()
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let card = self?.card else { return }
            Repository.shared.delete(card, board:List.shared.selected.board)
            Repository.shared.scheduleUpdate(List.shared.selected.board)
            DispatchQueue.main.async { [weak self] in
                Progress.shared.update()
                self?.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        Canvas.shared.parent(self)?.child = child
        Canvas.shared.update()
    }
}
