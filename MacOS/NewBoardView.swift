import AppKit

class NewBoardView:NSWindow, NSTextFieldDelegate {
    private weak var name:NSTextField!
    private weak var none:NSButton!
    private weak var single:NSButton!
    private weak var double:NSButton!
    private weak var triple:NSButton!
    private weak var columns:NSTextField!
    private weak var selectorLeft:NSLayoutConstraint!
    private let presenter:Presenter!
    override var canBecomeKey:Bool { return true }
    
    init(_ presenter:Presenter) {
        self.presenter = presenter
        super.init(contentRect:NSRect(x:0, y:0, width:Application.view.frame.width - 2, height:
            Application.view.frame.height - 2), styleMask:[], backing:.buffered, defer:false)
        isOpaque = false
        backgroundColor = .clear
        contentView!.wantsLayer = true
        contentView!.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
        contentView!.layer!.cornerRadius = 4
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:18, weight:.bold)
        title.stringValue = .local("NewBoardView.title")
        contentView!.addSubview(title)
        
        let columns = NSTextField()
        columns.translatesAutoresizingMaskIntoConstraints = false
        columns.backgroundColor = .clear
        columns.isBezeled = false
        columns.isEditable = false
        columns.font = .systemFont(ofSize:12, weight:.light)
        columns.alphaValue = 0.4
        contentView!.addSubview(columns)
        self.columns = columns
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isBezeled = false
        name.font = .systemFont(ofSize:18, weight:.regular)
        name.placeholderString = .local("NewBoardView.name")
        name.focusRingType = .none
        name.drawsBackground = false
        name.refusesFirstResponder = true
        name.delegate = self
        contentView!.addSubview(name)
        self.name = name
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.textColor.withAlphaComponent(0.2).cgColor
        contentView!.addSubview(border)
        
        let cancel = NSButton()
        cancel.title = .local("NewBoardView.cancel")
        cancel.target = self
        cancel.action = #selector(self.cancel)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.font = .systemFont(ofSize:18, weight:.regular)
        cancel.keyEquivalent = "\u{1b}"
        contentView!.addSubview(cancel)
        
        let selector = NSView()
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.wantsLayer = true
        selector.layer!.backgroundColor = NSColor.velvetBlue.cgColor
        selector.layer!.cornerRadius = 4
        contentView!.addSubview(selector)
        
        let none = NSButton()
        none.translatesAutoresizingMaskIntoConstraints = false
        none.image = NSImage(named:"noneOff")
        none.target = self
        none.action = #selector(selectNone)
        none.isBordered = false
        none.imageScaling = .scaleNone
        contentView!.addSubview(none)
        self.none = none
        
        let single = NSButton()
        single.translatesAutoresizingMaskIntoConstraints = false
        single.image = NSImage(named:"singleOff")
        single.target = self
        single.action = #selector(selectSingle)
        single.isBordered = false
        single.imageScaling = .scaleNone
        contentView!.addSubview(single)
        self.single = single
        
        let double = NSButton()
        double.translatesAutoresizingMaskIntoConstraints = false
        double.image = NSImage(named:"doubleOff")
        double.target = self
        double.action = #selector(selectDouble)
        double.isBordered = false
        double.imageScaling = .scaleNone
        contentView!.addSubview(double)
        self.double = double
        
        let triple = NSButton()
        triple.translatesAutoresizingMaskIntoConstraints = false
        triple.image = NSImage(named:"tripleOff")
        triple.target = self
        triple.action = #selector(selectTriple)
        triple.isBordered = false
        triple.imageScaling = .scaleNone
        contentView!.addSubview(triple)
        self.triple = triple
        
        title.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:-160).isActive = true
        title.bottomAnchor.constraint(equalTo:name.topAnchor, constant:-40).isActive = true
        
        name.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant:310).isActive = true
        name.bottomAnchor.constraint(equalTo:border.topAnchor, constant:-10).isActive = true
        
        border.bottomAnchor.constraint(equalTo:contentView!.centerYAnchor, constant:-80).isActive = true
        border.leftAnchor.constraint(equalTo:name.leftAnchor, constant:-5).isActive = true
        border.rightAnchor.constraint(equalTo:name.rightAnchor, constant:5).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        selector.widthAnchor.constraint(equalToConstant:44).isActive = true
        selector.heightAnchor.constraint(equalToConstant:44).isActive = true
        selector.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        selectorLeft = selector.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor)
        selectorLeft.isActive = true
        
        none.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        none.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:-180).isActive = true
        none.widthAnchor.constraint(equalToConstant:80).isActive = true
        none.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        single.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        single.leftAnchor.constraint(equalTo:none.rightAnchor, constant:20).isActive = true
        single.widthAnchor.constraint(equalToConstant:80).isActive = true
        single.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        double.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        double.leftAnchor.constraint(equalTo:single.rightAnchor).isActive = true
        double.widthAnchor.constraint(equalToConstant:80).isActive = true
        double.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        triple.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        triple.leftAnchor.constraint(equalTo:double.rightAnchor, constant:20).isActive = true
        triple.widthAnchor.constraint(equalToConstant:80).isActive = true
        triple.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        columns.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:-160).isActive = true
        columns.topAnchor.constraint(equalTo:contentView!.centerYAnchor, constant:35).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:-160).isActive = true
        cancel.topAnchor.constraint(equalTo:contentView!.centerYAnchor, constant:120).isActive = true
        
        selectTriple()
    }
    
    func control(_:NSControl, textView:NSTextView, doCommandBy selector:Selector) -> Bool {
        if (selector == #selector(NSResponder.insertNewline(_:))) {
            makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    private func moveSelector(_ left:CGFloat) {
        selectorLeft.constant = left
        if #available(OSX 10.12, *) {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.35
                context.allowsImplicitAnimation = true
                self.contentView!.layoutSubtreeIfNeeded()
            }
        }
    }
    
    @objc private func selectNone() {
        none.image = NSImage(named:"noneOn")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(-140)
        columns.stringValue = .local("NewBoardView.none")
    }
    
    @objc private func selectSingle() {
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOn")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(-40)
        columns.stringValue = .local("NewBoardView.single")
    }
    
    @objc private func selectDouble() {
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOn")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(40)
        columns.stringValue = .local("NewBoardView.double")
    }
    
    @objc private func selectTriple() {
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOn")
        moveSelector(140)
        columns.stringValue = .local("NewBoardView.triple")
    }
    
    @objc private func cancel() {
        Application.view.endSheet(self)
    }
    
    @objc private func delete() {
        Application.view.endSheet(self)
    }
}
