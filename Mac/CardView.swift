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
            NSApp.mainWindow!.makeFirstResponder(nil)
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
        var column = View.canvas.root
        while column!.sibling is ColumnView {
            guard
                column!.sibling!.left.constant < event.locationInWindow.x -
                    Application.shared.view.listLeft.constant +
                    View.canvas.documentVisibleRect.origin.x
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
        Application.shared.view.canvasChanged()
        Application.shared.view.repository.move(card, board:Application.shared.view.selected!, column:(column as! ColumnView).column,
                                         after:(after as? CardView)?.card)
        Application.shared.view.scheduleUpdate()
        Application.shared.view.progress.chart = Application.shared.view.selected!.chart
    }
    
    override func updateSkin() {
        text.textColor = Application.shared.skin.text
        text.font = .light(Application.shared.skin.font)
        text.string = card.content
        super.updateSkin()
    }
    
    private func confirmDelete() {
        detach()
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let card = self?.card else { return }
            Application.shared.view.repository.delete(card, board:Application.shared.view.selected!)
            Application.shared.view.scheduleUpdate()
            DispatchQueue.main.async { [weak self] in
                Application.shared.view.progress.chart = Application.shared.view.selected!.chart
                self?.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if let parent = Application.shared.view.canvas.documentView!.subviews.first(
            where: {($0 as? ItemView)?.child === self }) as? ItemView {
            parent.child = child
            Application.shared.view.canvasChanged()
        }
    }
}
