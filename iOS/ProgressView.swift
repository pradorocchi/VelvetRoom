import UIKit

class ProgressView:UIControl {
    var progress:Float = 0 { didSet {
        width.constant = CGFloat(progress) * 24
        UIView.animate(withDuration:1) { self.layoutIfNeeded() }
    } }
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    private weak var width:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.cornerRadius = 2
        background.backgroundColor = UIColor.velvetBlue.withAlphaComponent(0.4)
        background.clipsToBounds = true
        background.isUserInteractionEnabled = false
        addSubview(background)
        
        let progress = UIView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.backgroundColor = .velvetBlue
        progress.isUserInteractionEnabled = false
        background.addSubview(progress)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize:12, weight:.bold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "%"
        addSubview(label)
        
        background.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant:20).isActive = true
        background.widthAnchor.constraint(equalToConstant:24).isActive = true
        
        progress.leftAnchor.constraint(equalTo:background.leftAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        progress.heightAnchor.constraint(equalTo:background.heightAnchor).isActive = true
        width = progress.widthAnchor.constraint(equalToConstant:0)
        width.isActive = true
        
        label.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-1).isActive = true
        label.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func update() {
        if isSelected || isHighlighted {
            alpha = 0.2
        } else {
            alpha = 1
        }
    }
}
