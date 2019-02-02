import AppKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.textContainer!.size = NSSize(width:420, height:1000000)
        self.card = card
        updateSkin()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textDidEndEditing(_ notification:Notification) {
        card.content = text.string
        if card.content.isEmpty {
            Application.view.makeFirstResponder(nil)
            confirmDelete()
        } else {
            text.string = card.content
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
                column!.sibling!.left.constant < event.locationInWindow.x -
                    Application.view.listLeft.constant + Application.view.canvas.documentVisibleRect.origin.x
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
        Application.view.progress.chart = Application.view.selected!.chart
    }
    
    override func updateSkin() {
        text.textColor = Application.skin.text
        text.font = .light(Application.skin.font)
        text.string = card.content
        super.updateSkin()
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
        if let parent = Application.view.canvas.documentView!.subviews.first(
            where: {($0 as? ItemView)?.child === self }) as? ItemView {
            parent.child = child
            Application.view.canvasChanged()
        }
    }
}
