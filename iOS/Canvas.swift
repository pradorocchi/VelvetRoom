import UIKit
import VelvetRoom

class Canvas:UIScrollView {
    static let shared = Canvas()
    weak var root:Item?
    private(set) weak var content:UIView!
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
    
    func parent(_ of:CardItem) -> Item? {
        return content.subviews.first(where:{ ($0 as? Item)?.child === of } ) as? Item
    }
    
    private func render(_ board:Board) {
        content.subviews.forEach { $0.removeFromSuperview() }
        root = nil
        var sibling:Item?
        board.columns.enumerated().forEach { (index, item) in
            let column = ColumnItem(item)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            content.addSubview(column)
            var child:Item = column
            sibling = column
            
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardItem($0)
                content.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let buttonColumn = Create(#selector(newColumn(_:)))
        content.addSubview(buttonColumn)
        
        if root == nil {
            root = buttonColumn
        } else {
            sibling!.sibling = buttonColumn
        }
    }
    
    private func align() {
        var maxRight = CGFloat(10)
        var maxBottom = CGFloat()
        var sibling = root
        while sibling != nil {
            let right = maxRight
            var bottom = CGFloat(60 + App.shared.margin.top)
            
            var child = sibling
            sibling = sibling!.sibling
            while child != nil {
                child!.left.constant = right
                child!.top.constant = bottom
                
                bottom += child!.bounds.height + 30
                maxRight = max(maxRight, right + child!.bounds.width + 45)
                
                child = child!.child
            }
            
            maxBottom = max(bottom, maxBottom)
        }
        width = content.widthAnchor.constraint(greaterThanOrEqualToConstant:maxRight - 40)
        height = content.heightAnchor.constraint(greaterThanOrEqualToConstant:maxBottom + 20 + App.shared.margin.bottom)
    }
    
    private func addCarder() {
        if root != nil, !(root is Create), !(root!.child is Create) {
            let carder = Create(#selector(newCard(_:)))
            carder.child = root!.child
            root!.child = carder
            content.addSubview(carder)
        }
    }
    
    @objc private func newColumn(_ view:Create) {
        let column = ColumnItem(Repository.shared.newColumn(List.shared.selected.board))
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
        content.addSubview(column)
        column.top.constant = view.top.constant
        column.left.constant = view.left.constant
        update()
        column.beginEditing()
        Repository.shared.scheduleUpdate(List.shared.selected.board)
    }
    
    @objc private func newCard(_ view:Create) {
        let card = CardItem(try! Repository.shared.newCard(List.shared.selected.board))
        card.child = view.child
        view.child = card
        content.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        update()
        card.beginEditing()
        Repository.shared.scheduleUpdate(List.shared.selected.board)
    }
    
    @objc private func updateSkin() {
        indicatorStyle = Skin.shared.scroll
    }
}
