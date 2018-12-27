import Foundation
import VelvetRoom

class DeleteColumnView:DeleteView {
    private weak var board:Board!
    private var column:ColumnView!
    
    init(_ column:ColumnView, board:Board) {
        super.init()
        message.stringValue = .local("DeleteColumnView.message")
        self.board = board
        self.column = column
    }
    
    override func delete() {
        Application.shared.view.deleteConfirm(column, board:board)
        super.delete()
    }
}
