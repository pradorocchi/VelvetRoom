import UIKit
import VelvetRoom

class List:UIScrollView {
    static let shared = List()
    weak var selected:BoardItem! { didSet { oldValue?.updateSkin(); selected?.updateSkin() } }
    weak var right:NSLayoutConstraint! { didSet { right.isActive = true } }
    weak var bottom:NSLayoutConstraint! { didSet { bottom.isActive = true } }
    private weak var content:UIView!
    
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
        content.widthAnchor.constraint(equalTo:widthAnchor).isActive = true
        
        Repository.shared.list = { boards in DispatchQueue.main.async { self.render(boards) } }
        Repository.shared.select = { board in DispatchQueue.main.async {
            self.select(item:self.content.subviews.first(where:{ ($0 as! BoardItem).board === board }) as! BoardItem) }
        }
        
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
    
    private func render(_ boards:[Board]) {
        Bar.shared.list()
        content.subviews.forEach { $0.removeFromSuperview() }
        scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated:true)
        var top = content.topAnchor
        boards.enumerated().forEach {
            let item = BoardItem($0.element)
            item.addTarget(self, action:#selector(select(item:)), for:.touchUpInside)
            content.addSubview(item)
            
            item.topAnchor.constraint(equalTo:top,
                                      constant:$0.offset == 0 ? 70 + App.shared.margin.top : 10).isActive = true
            item.leftAnchor.constraint(equalTo:content.leftAnchor, constant:20).isActive = true
            item.rightAnchor.constraint(equalTo:content.rightAnchor, constant:20).isActive = true
            top = item.bottomAnchor
        }
        if !boards.isEmpty {
            content.bottomAnchor.constraint(equalTo:top, constant:50 + App.shared.margin.bottom).isActive = true
        }
        content.layoutIfNeeded()
    }
    
    @objc private func select(item:BoardItem) {
        UIApplication.shared.keyWindow!.endEditing(true)
        selected = item
        right.constant = App.shared.rootViewController!.view.bounds.width
        Progress.shared.update()
        Canvas.shared.display(item.board)
    }
}
