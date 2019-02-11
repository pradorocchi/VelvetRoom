import UIKit
import VelvetRoom

class Canvas:UIScrollView {
    static let shared = Canvas()
    weak var root:ItemView?
    private weak var content:UIView!
    private weak var width:NSLayoutConstraint? { didSet { oldValue?.isActive = false; width!.isActive = true } }
    private weak var height:NSLayoutConstraint? { didSet { oldValue?.isActive = false; height!.isActive = true } }
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
        showsVerticalScrollIndicator = false
        
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        self.content = content
        
        content.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        content.topAnchor.constraint(equalTo:topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        content.heightAnchor.constraint(greaterThanOrEqualTo:heightAnchor).isActive = true
//        content.widthAnchor.constraint(greaterThanOrEqualTo:view.widthAnchor).isActive = true
        
        if #available(iOS 11.0, *) { contentInsetAdjustmentBehavior = .never }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ animation:TimeInterval = 0.5) {
        addCarder()
        content.layoutIfNeeded()
        align()
        UIView.animate(withDuration:animation) {
            self.content.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(Repository.shared.newColumn(selected!))
        column.sibling = view
        if root === view {
            root = column
        } else {
            var left = root
            while left!.sibling !== view {
                left = left!.sibling
            }
            left!.sibling = column
        }
        canvas.addSubview(column)
        column.top.constant = view.top.constant
        column.left.constant = view.left.constant
        canvasChanged()
        column.beginEditing()
        scheduleUpdate()
    }
    
    @objc private func newCard(_ view:CreateView) {
        let card = CardView(try! Repository.shared.newCard(selected!))
        card.child = view.child
        view.child = card
        canvas.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        scheduleUpdate()
        progress.chart = selected!.chart
    }
}
