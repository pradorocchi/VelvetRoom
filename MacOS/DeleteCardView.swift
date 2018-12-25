import Foundation
import VelvetRoom

class DeleteCardView:DeleteView {
    private weak var cardView:CardView?
    private weak var board:Board!
    private weak var card:Card!
    
    init(_ card:CardView, board:Board, view:View) {
        super.init(view)
        message.stringValue = .local("DeleteCardView.message")
        self.board = board
        self.cardView = card
        self.card = card.card
    }
    
    override func delete() {
        view.delete(card, view:cardView, board:board)
        super.delete()
    }
}
