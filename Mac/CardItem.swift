import AppKit
import VelvetRoom

class CardItem:Edit {
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
            Window.shared.makeFirstResponder(nil)
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
        var column = Canvas.shared.root
        while column!.sibling is ColumnItem {
            guard
                column!.sibling!.left.constant < event.locationInWindow.x - List.shared.left.constant +
                    Canvas.shared.documentVisibleRect.origin.x
            else { break }
            column = column!.sibling
        }
        var after = column
        while after!.child != nil {
            guard after!.child!.top.constant < top.constant else { break }
            after = after!.child
        }
        if after!.child is Create {
            after = after?.child
        }
        child = after!.child
        after!.child = self
        Repository.shared.move(card, board:List.shared.selected.board, column:(column as! ColumnItem).column,
                               after:(after as? CardItem)?.card)
        super.endDrag(event)
    }
    
    override func updateSkin() {
        text.textColor = Skin.shared.text
        text.font = .light(Skin.shared.font)
        text.string = card.content
        super.updateSkin()
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
        (Canvas.shared.documentView!.subviews.first(where:{ ($0 as? Item)?.child === self } ) as? Item)?.child = child
        Canvas.shared.update()
    }
}
