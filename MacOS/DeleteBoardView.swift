import Foundation
import VelvetRoom

class DeleteBoardView:DeleteView {
    private weak var board:Board!
    
    init(_ board:Board, view:View) {
        super.init(view)
        message.stringValue = .local("DeleteBoardView.message")
        self.board = board
    }
    
    override func delete() {
        view.presenter.delete(board)
        super.delete()
    }
}
