import AppKit
import VelvetRoom

class CardView:EditView {
    private(set) weak var card:Card!
    
    init(_ card:Card) {
        super.init()
        text.textContainer!.size = NSSize(width:400, height:1000000)
        text.font = .light(14)
        text.string = card.content
        text.update()
        self.card = card
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func textDidEndEditing(_ notification:Notification) {
        card.content = text.string
        if card.content.isEmpty {
            Application.shared.view.makeFirstResponder(nil)
            Application.shared.view.beginSheet(DeleteView(.local("DeleteView.card")) { [weak self] in
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
        Application.shared.view.endDrag(self)
    }
    
    private func confirmDelete() {
        detach()
        DispatchQueue.global(qos:.background).async {
            Application.shared.view.presenter.repository.delete(self.card, board:Application.shared.view.presenter.selected.board)
            Application.shared.view.presenter.scheduleUpdate()
            DispatchQueue.main.async {
                Application.shared.view.progress.progress = Application.shared.view.presenter.selected.board.progress
                self.removeFromSuperview()
            }
        }
    }
    
    private func detach() {
        if let parent = Application.shared.view.canvas.documentView!.subviews.first(
            where: {($0 as! ItemView).child === self }) as? ItemView {
            parent.child = child
            Application.shared.view.canvasChanged()
        }
    }
}
