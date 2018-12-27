import Foundation
import VelvetRoom

class DeleteCardView:DeleteView {
    private weak var board:Board!
    private var card:CardView!
    
    init(_ card:CardView, board:Board) {
        super.init()
        message.stringValue = .local("DeleteCardView.message")
        self.board = board
        self.card = card
    }
    
    override func delete() {
        Application.shared.view.deleteConfirm(card, board:board)
        super.delete()
    }
}
