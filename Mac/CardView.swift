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
        super.endDrag(event)
        var column = Canvas.shared.root
        while column!.sibling is ColumnView {
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
        if after!.child is Creator {
            after = after?.child
        }
        child = after!.child
        after!.child = self
        Canvas.shared.update()
        Repository.shared.move(card, board:List.shared.current!.board, column:(column as! ColumnView).column,
                               after:(after as? CardView)?.card)
        List.shared.scheduleUpdate()
        Progress.shared.update()
    }
    
    override func updateSkin() {
        text.textColor = Skin.shared.text
        text.font = .light(Skin.shared.font)
        text.string = card.content
        super.updateSkin()
    }
    
    private func confirmDelete() {
        detach()
        guard let board = List.shared.current!.board else { return }
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let card = self?.card else { return }
            Repository.shared.delete(card, board:board)
            List.shared.scheduleUpdate()
            DispatchQueue.main.async { [weak self] in
                Progress.shared.update()
                self?.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        (Canvas.shared.documentView!.subviews.first(
            where:{($0 as? Item)?.child === self }) as? Item)?.child = child
        Canvas.shared.update()
    }
}
