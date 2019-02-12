import UIKit
import VelvetRoom

class List:UIScrollView {
    static let shared = List()
    private(set) weak var right:NSLayoutConstraint!
    private weak var content:UIView!
    private weak var bottom:NSLayoutConstraint!
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        self.content = content
        
        content.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        content.topAnchor.constraint(equalTo:topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
//        content.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        
        Repository.shared.select = { board in DispatchQueue.main.async { /* self.selecta(board) */} }
        Repository.shared.list = { boards in DispatchQueue.main.async {
            self.render(boards)
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
        
        if #available(iOS 11.0, *) { contentInsetAdjustmentBehavior = .never }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        right = rightAnchor.constraint(equalTo:superview!.rightAnchor)
        bottom = bottomAnchor.constraint(equalTo:superview!.bottomAnchor)
        right.isActive = true
        bottom.isActive = true
    }
    
    @objc private func showList() {
        UIApplication.shared.keyWindow!.endEditing(true)
        progress.chart = []
        loadLeft.constant = 0
        chartLeft.constant = 0
        boardsRight.constant = 0
        UIView.animate(withDuration:0.4, animations: {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 0
        }) { _ in
            self.canvas.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    private func render(_ boards:[Board]) {
        self.boards.subviews.forEach { $0.removeFromSuperview() }
        (self.boards.superview as! UIScrollView).scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated:true)
        var top = self.boards.topAnchor
        boards.enumerated().forEach { board in
            let view = BoardView(board.element)
            self.boards.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top, constant:board.offset == 0 ? 60 + safeTop : 10).isActive = true
            view.leftAnchor.constraint(equalTo:self.boards.leftAnchor, constant:20).isActive = true
            view.rightAnchor.constraint(equalTo:self.boards.rightAnchor, constant:20).isActive = true
            top = view.bottomAnchor
        }
        if boards.isEmpty {
            emptyButton.isHidden = false
        } else {
            emptyButton.isHidden = true
            self.boards.bottomAnchor.constraint(equalTo:top, constant:10 + safeBottom).isActive = true
        }
        self.boards.layoutIfNeeded()
    }
    
    @objc private func selecta(_ item:BoardView) {
        /*selected = board
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
        }*/
    }
}
