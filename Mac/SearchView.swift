import AppKit

class SearchView:NSView, NSTextViewDelegate {
    private(set) weak var text:TextView!
    private(set) weak var highlighter:NSView?
    private weak var bottom:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        layer!.borderWidth = 1
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = NSImage(named:"searchIcon")
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let text = TextView()
        text.textContainer!.size = NSSize(width:365, height:40)
        text.font = .light(18)
        text.delegate = self
        self.text = text
        addSubview(text)
        
        let done = NSButton()
        done.target = self
        done.action = #selector(self.done)
        done.image = NSImage(named:"close")
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
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:image.rightAnchor).isActive = true
        
        done.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        done.rightAnchor.constraint(equalTo:rightAnchor, constant:-15).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:24).isActive = true
        
        updateSkin()
        Skin.add(self, selector:#selector(updateSkin))
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
            Application.shared.view.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    func textDidChange(_:Notification) {
        if self.highlighter == nil {
            let highlighter = NSView()
            highlighter.wantsLayer = true
            highlighter.layer!.backgroundColor = NSColor.velvetBlue.cgColor
            highlighter.layer!.cornerRadius = 4
            Application.shared.view.canvas.contentView.addSubview(highlighter, positioned:.below, relativeTo:nil)
            self.highlighter = highlighter
        }
        
        var range:Range<String.Index>!
        guard let view = Application.shared.view.canvas.documentView!.subviews.first (where: {
            guard
                let view = $0 as? EditView,
                let textRange = view.text.string.range(of:text.string, options:.caseInsensitive)
            else { return false }
            range = textRange
            return true
        }) as? EditView else { return highlighter!.frame = .zero }
        var frame = Application.shared.view.canvas.contentView.convert(view.text.layoutManager!.boundingRect(
            forGlyphRange:NSRange(range, in:view.text.string), in:view.text.textContainer!), from:view.text)
        frame.origin.x -= 10
        frame.size.width += 20
        highlighter!.frame = frame
        frame.origin.x -= (Application.shared.view.contentView!.bounds.width - frame.size.width) / 2
        frame.origin.y -= Application.shared.view.contentView!.bounds.midY
        frame.size.width = Application.shared.view.contentView!.bounds.width
        frame.size.height = Application.shared.view.contentView!.bounds.height
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            Application.shared.view.canvas.contentView.scrollToVisible(frame)
        }, completionHandler:nil)
    }
    
    func active() {
        bottom.constant = 100
        text.isEditable = true
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            superview!.layoutSubtreeIfNeeded()
        }) {
            Application.shared.view.makeFirstResponder(self.text)
        }
    }
    
    func unactive() {
        bottom.constant = 0
        text.isEditable = false
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            highlighter?.alphaValue = 0
            superview!.layoutSubtreeIfNeeded()
        }) {
            self.highlighter?.removeFromSuperview()
            self.text.string = String()
        }
    }
    
    @objc private func updateSkin() {
        layer!.backgroundColor = Application.shared.skin.background.withAlphaComponent(0.95).cgColor
        layer!.borderColor = Application.shared.skin.text.withAlphaComponent(0.3).cgColor
        text.textColor = Application.shared.skin.text
    }
    
    @objc private func done() {
        Application.shared.view.makeFirstResponder(nil)
    }
}
