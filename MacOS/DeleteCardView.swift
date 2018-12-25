import Foundation
import VelvetRoom

class DeleteCardView:DeleteView {
    private weak var board:Board!
    private var card:CardView!
    
    init(_ card:CardView, board:Board, view:View) {
        super.init(view)
        message.stringValue = .local("DeleteCardView.message")
        self.board = board
        self.card = card
    }
    
    override func delete() {
        view.deleteConfirm(card, board:board)
        super.delete()
    }
}
