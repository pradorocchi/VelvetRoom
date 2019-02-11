import UIKit

class Progress:UIView {
    static let shared = Progress()
    private weak var marker:NSLayoutXAxisAnchor!
    private var views = [UIView]()
    private var widths = [NSLayoutConstraint]()
    var chart = [(String, Float)]() { didSet {
        let items = chart.compactMap({ $0.1 > 0 ? $0.1 : nil })
        while items.count < views.count { views.removeLast().removeFromSuperview() }
        while items.count > views.count {
            let view = UIView()
            view.isUserInteractionEnabled = false
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = Application.skin.text.withAlphaComponent(0.2)
            addSubview(view)
            view.topAnchor.constraint(equalTo:topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
            view.leftAnchor.constraint(
                equalTo:views.isEmpty ? marker : views.last!.rightAnchor, constant:2).isActive = true
            views.append(view)
        }
        layoutIfNeeded()
        widths.forEach({ $0.isActive = false })
        items.enumerated().forEach {
            widths.append(views[$0.offset].widthAnchor.constraint(equalTo:widthAnchor, multiplier:CGFloat($0.element)))
            widths.last!.isActive = true
        }
        UIView.animate(withDuration:1) { [weak self] in self?.layoutIfNeeded() }
    } }
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        clipsToBounds = true
        layer.cornerRadius = 2
        
        let marker = UIView()
        marker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(marker)
        marker.leftAnchor.constraint(equalTo:leftAnchor, constant:-2).isActive = true
        self.marker = marker.leftAnchor
        
        heightAnchor.constraint(equalToConstant:10).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
