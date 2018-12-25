import Foundation
import VelvetRoom

class DeleteColumnView:DeleteView {
    private weak var board:Board!
    private var column:ColumnView!
    
    init(_ column:ColumnView, board:Board, view:View) {
        super.init(view)
        message.stringValue = .local("DeleteColumnView.message")
        self.board = board
        self.column = column
    }
    
    override func delete() {
        view.deleteConfirm(column, board:board)
        super.delete()
    }
}
