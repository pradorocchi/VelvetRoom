import AppKit

class SearchView:NSView, NSTextViewDelegate {
    private weak var bottom:NSLayoutConstraint! { didSet { bottom.isActive = true } }
    private(set) weak var field:TextView!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 4
        layer!.borderWidth = 1
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = NSImage(named:"searchIcon")
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let field = TextView()
        field.textContainer!.size = NSSize(width:280, height:40)
        field.font = .light(18)
        field.delegate = self
        field.update()
        self.field = field
        addSubview(field)
        
        let done = NSButton()
        done.target = self
        done.action = #selector(self.done)
        done.image = NSImage(named:"delete")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.keyEquivalent = "\u{1b}"
        done.title = String()
        addSubview(done)
        
        widthAnchor.constraint(equalToConstant:450).isActive = true
        heightAnchor.constraint(equalToConstant:60).isActive = true
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor, constant:4).isActive = true
        image.widthAnchor.constraint(equalToConstant:36).isActive = true
        
        field.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        field.leftAnchor.constraint(equalTo:image.rightAnchor).isActive = true
        
        done.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        done.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        updateSkin()
        NotificationCenter.default.addObserver(forName:.init("skin"), object:nil, queue:OperationQueue.main) { _ in
            self.updateSkin()
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        bottom = bottomAnchor.constraint(equalTo:superview!.topAnchor)
        bottom.isActive = true
    }
    
    func textDidEndEditing(_:Notification) {
        unactive()
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Application.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    func active() {
        bottom.constant = 100
        field.isEditable = true
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            superview!.layoutSubtreeIfNeeded()
        }) {
            Application.view.makeFirstResponder(self.field)
        }
    }
    
    func unactive() {
        bottom.constant = 0
        field.isEditable = false
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            superview!.layoutSubtreeIfNeeded()
        }) {
            self.field.string = String()
        }
    }
    
    private func updateSkin() {
        layer!.backgroundColor = Application.skin.background.cgColor
        layer!.borderColor = Application.skin.text.withAlphaComponent(0.3).cgColor
    }
    
    @objc private func done() {
        Application.view.makeFirstResponder(nil)
    }
}
