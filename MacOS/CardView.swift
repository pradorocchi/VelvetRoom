import AppKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.textContainer!.size = NSSize(width:400, height:1000000)
        text.font = .light(CGFloat(Application.view.repository.account.font))
        text.string = card.content
        text.update()
        self.card = card
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textDidEndEditing(_ notification:Notification) {
        card.content = text.string
        if card.content.isEmpty {
            Application.view.makeFirstResponder(nil)
            Application.view.beginSheet(DeleteView(.local("DeleteView.card")) { [weak self] in
                self?.confirmDelete()
            })
        } else {
            text.string = card.content
            text.update()
        }
        super.textDidEndEditing(notification)
    }
    
    override func beginDrag() {
        super.beginDrag()
        detach()
    }
    
    override func endDrag(_ event:NSEvent) {
        super.endDrag(event)
        var column = Application.view.root
        while column!.sibling is ColumnView {
            guard
                column!.sibling!.left.constant < event.locationInWindow.x - Application.view.borderLeft.constant
                    + Application.view.canvas.documentVisibleRect.origin.x
            else { break }
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
        Application.view.progress.progress = Application.view.selected!.progress
    }
    
    private func confirmDelete() {
        detach()
        DispatchQueue.global(qos:.background).async {
            Application.view.repository.delete(self.card, board:Application.view.selected!)
            Application.view.scheduleUpdate()
            DispatchQueue.main.async {
                Application.view.progress.progress = Application.view.selected!.progress
                self.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if let parent = Application.view.canvas.documentView!.subviews.first(
            where: {($0 as! ItemView).child === self }) as? ItemView {
            parent.child = child
            Application.view.canvasChanged()
        }
    }
}
