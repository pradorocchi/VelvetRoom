import Foundation
import VelvetRoom

class DeleteBoardView:DeleteView {
    private weak var board:Board!
    
    init(_ board:Board) {
        super.init()
        message.stringValue = .local("DeleteBoardView.message")
        self.board = board
    }
    
    override func delete() {
        Application.shared.view.presenter.delete(board)
        super.delete()
    }
}
