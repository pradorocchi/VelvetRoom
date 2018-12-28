import UIKit

class ProgressView:UIControl {
    private weak var label:UILabel!
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
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize:12, weight:.bold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "%"
        label.isHidden = true
        addSubview(label)
        self.label = label
        
        background.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant:18).isActive = true
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
    
    func progress(_ value:CGFloat) {
        label.isHidden = false
        animate(value * 24)
    }
    
    func clear() {
        label.isHidden = true
        animate(0)
    }
    
    private func animate(_ value:CGFloat) {
        width.constant = value
        UIView.animate(withDuration:1) { self.layoutIfNeeded() }
    }
}
