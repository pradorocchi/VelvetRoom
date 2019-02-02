import UIKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.font = .light(CGFloat(Application.view.repository.account.font))
        text.text = card.content
        text.onDelete = { [weak self] in
            guard self?.text.text.isEmpty == false else { return }
            Application.view.present(DeleteView { [weak self] in self?.confirmDelete() }, animated:true)
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
        super.endDrag()
        var column = Application.view.root
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
        Application.view.canvasChanged()
        Application.view.repository.move(card, board:Application.view.selected!, column:(column as! ColumnView).column,
                                         after:(after as? CardView)?.card)
        Application.view.scheduleUpdate()
        Application.view.progress.chart = Application.view.selected!.chart
    }
    
    private func confirmDelete() {
        detach()
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let card = self?.card else { return }
            Application.view.repository.delete(card, board:Application.view.selected!)
            Application.view.scheduleUpdate()
            DispatchQueue.main.async { [weak self] in
                Application.view.progress.chart = Application.view.selected!.chart
                self?.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if let parent = Application.view.canvas.subviews.first(where:
            { ($0 as? ItemView)?.child === self } ) as? ItemView {
            parent.child = child
            Application.view.canvasChanged()
        }
    }
}
