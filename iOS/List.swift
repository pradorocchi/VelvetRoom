import UIKit
import VelvetRoom

class List:UIView {
    static let shared = List()
    private weak var boardsBottom:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var boardsRight:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    
    private init() {
        super.init(frame:.zero)
        
        Repository.shared.select = { board in DispatchQueue.main.async { self.open(board) } }
        Repository.shared.list = { boards in DispatchQueue.main.async {
            self.list(boards)
            self.showList()
            } }
    }
    
    required init?(coder:NSCoder) { return nil }
}
