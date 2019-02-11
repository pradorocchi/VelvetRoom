import UIKit
import VelvetRoom

class List:UIView {
    static let shared = List()
    private(set) weak var right:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var bottom:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    
    private init() {
        super.init(frame:.zero)
        
        Repository.shared.select = { board in DispatchQueue.main.async { self.open(board) } }
        Repository.shared.list = { boards in DispatchQueue.main.async {
            self.list(boards)
            self.showList()
            } }
        
        NotificationCenter.default.addObserver(
        forName:UIResponder.keyboardWillChangeFrameNotification, object:nil, queue:.main) {
            self.bottom.constant = {
                $0.minY < self.bounds.height ? -$0.height : 0
            } (($0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue)
            UIView.animate(withDuration:
            ($0.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue) {
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func select(_ board:Board) {
        selected = board
        progress.chart = board.chart
        titleLabel.text = board.name
        loadLeft.constant = -256
        chartLeft.constant = -192
        boardsRight.constant = view.bounds.width
        (canvas.superview as! UIScrollView).scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated:false)
        canvas.alpha = 0
        UIView.animate(withDuration:0.5, animations: {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 1
        }) { _ in
            self.render(board)
            self.canvasChanged(0)
            UIView.animate(withDuration:0.35) {
                self.canvas.alpha = 1
            }
        }
    }
}
