import AppKit

class ProgressView:NSView {
    var progress:Float = 0 { didSet {
        label.isHidden = false
        animate(CGFloat(progress) * bounds.width)
    } }
    private weak var label:NSTextField!
    private weak var width:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 2
        layer!.borderWidth = 1
        
        let progress = NSView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.wantsLayer = true
        progress.layer!.backgroundColor = NSColor.velvetBlue.cgColor
        addSubview(progress)
        
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
        
        progress.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        progress.heightAnchor.constraint(equalTo:heightAnchor).isActive = true
        width = progress.widthAnchor.constraint(equalToConstant:0)
        width.isActive = true
        
        label.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-1).isActive = true
        label.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        heightAnchor.constraint(equalToConstant:18).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
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
