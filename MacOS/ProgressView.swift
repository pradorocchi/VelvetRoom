import AppKit

class ProgressView:NSControl {
    private weak var label:NSTextField!
    private weak var width:NSLayoutConstraint!
    
    override func mouseDown(with event:NSEvent) {
        if !label.isHidden {
            sendAction(action, to:target)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.cornerRadius = 2
        background.layer!.backgroundColor = NSColor.velvetBlue.withAlphaComponent(0.4).cgColor
        addSubview(background)
        
        let progress = NSView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.wantsLayer = true
        progress.layer!.backgroundColor = NSColor.velvetBlue.cgColor
        background.addSubview(progress)
        
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.isBezeled = false
        label.isEditable = false
        label.font = .systemFont(ofSize:12, weight:.bold)
        label.alignment = .center
        label.textColor = .black
        label.stringValue = "%"
        label.isHidden = true
        addSubview(label)
        self.label = label
        
        background.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        progress.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        progress.heightAnchor.constraint(equalTo:background.heightAnchor).isActive = true
        width = progress.widthAnchor.constraint(equalToConstant:0)
        width.isActive = true
        
        label.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-1).isActive = true
        label.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
    }
    
    func progress(_ value:CGFloat) {
        label.isHidden = false
        animate(value * bounds.width)
    }
    
    func clear() {
        label.isHidden = true
        animate(0)
    }
    
    private func animate(_ value:CGFloat) {
        width.constant = value
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                layoutSubtreeIfNeeded()
            }
        }
    }
}