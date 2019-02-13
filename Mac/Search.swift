import AppKit

class Search:NSView, NSTextViewDelegate {
    static let shared = Search()
    weak var bottom:NSLayoutConstraint! { didSet { bottom.isActive = true } }
    private(set) weak var text:Text!
    private(set) weak var highlighter:NSView?
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        alphaValue = 0
        layer!.cornerRadius = 12
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = NSImage(named:"searchIcon")
        image.imageScaling = .scaleNone
        addSubview(image)
        
        let text = Text()
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
        
        Skin.add(self)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textDidEndEditing(_:Notification) {
        unactive()
    }
    
    func textView(_:NSTextView, doCommandBy:Selector) -> Bool {
        if (doCommandBy == #selector(NSResponder.insertNewline(_:))) {
            Window.shared.makeFirstResponder(nil)
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
            Canvas.shared.contentView.addSubview(highlighter, positioned:.below, relativeTo:nil)
            self.highlighter = highlighter
        }
        highlighter!.frame = .zero
        for v in Canvas.shared.documentView!.subviews.compactMap( { $0 as? Edit } )  {
            if let range = v.text.string.range(of:text.string, options:.caseInsensitive) {
                var frame = Canvas.shared.contentView.convert(v.text.layoutManager!.boundingRect(
                    forGlyphRange:NSRange(range, in:v.text.string), in:v.text.textContainer!), from:v.text)
                frame.origin.x -= 10
                frame.size.width += 20
                highlighter!.frame = frame
                frame.origin.x -= (Window.shared.contentView!.bounds.width - frame.size.width) / 2
                frame.origin.y -= Window.shared.contentView!.bounds.midY
                frame.size.width = Window.shared.contentView!.bounds.width
                frame.size.height = Window.shared.contentView!.bounds.height
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.4
                    context.allowsImplicitAnimation = true
                    Canvas.shared.contentView.scrollToVisible(frame)
                }, completionHandler:nil)
                break
            }
        }
    }
    
    @objc func active() {
        Window.shared.makeFirstResponder(nil)
        bottom.constant = 100
        text.isEditable = true
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            alphaValue = 1
            superview!.layoutSubtreeIfNeeded()
        }) {
            Window.shared.makeFirstResponder(self.text)
        }
    }
    
    private func unactive() {
        bottom.constant = 0
        text.isEditable = false
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.4
            context.allowsImplicitAnimation = true
            alphaValue = 0
            highlighter?.alphaValue = 0
            superview!.layoutSubtreeIfNeeded()
        }) {
            self.highlighter?.removeFromSuperview()
            self.text.string = String()
        }
    }
    
    @objc private func updateSkin() {
        layer!.backgroundColor = Skin.shared.text.withAlphaComponent(0.96).cgColor
        text.textColor = Skin.shared.background
    }
    
    @objc private func done() {
        Window.shared.makeFirstResponder(nil)
    }
}
