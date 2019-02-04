import AppKit
import VelvetRoom
import StoreKit

class NewView:SheetView, NSTextFieldDelegate {
    private weak var name:NSTextField!
    private weak var none:NSButton!
    private weak var single:NSButton!
    private weak var double:NSButton!
    private weak var triple:NSButton!
    private weak var columns:NSTextField!
    private weak var selectorLeft:NSLayoutConstraint!
    private var template:Template!
    
    override init() {
        super.init()
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:18, weight:.bold)
        title.stringValue = .local("NewView.title")
        title.textColor = .white
        contentView!.addSubview(title)
        
        let columns = NSTextField()
        columns.translatesAutoresizingMaskIntoConstraints = false
        columns.backgroundColor = .clear
        columns.isBezeled = false
        columns.isEditable = false
        columns.font = .systemFont(ofSize:12, weight:.light)
        columns.alphaValue = 0.5
        columns.textColor = .white
        contentView!.addSubview(columns)
        self.columns = columns
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isBezeled = false
        name.font = .systemFont(ofSize:18, weight:.medium)
        name.placeholderAttributedString = NSAttributedString(string:.local("NewView.name"), attributes:
            [.font:NSFont.systemFont(ofSize:18, weight:.medium), .foregroundColor:NSColor(white:1, alpha:0.2)])
        name.focusRingType = .none
        name.drawsBackground = false
        name.delegate = self
        name.textColor = .white
        contentView!.addSubview(name)
        (name.window?.fieldEditor(true, for:name) as! NSTextView).insertionPointColor = .velvetBlue
        self.name = name
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor(white:1, alpha:0.4).cgColor
        contentView!.addSubview(border)
        
        let cancel = NSButton()
        cancel.target = self
        cancel.action = #selector(self.cancel)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.isBordered = false
        cancel.attributedTitle = NSAttributedString(string:.local("NewView.cancel"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.regular), .foregroundColor:NSColor(white:1, alpha:0.6)])
        cancel.keyEquivalent = "\u{1b}"
        contentView!.addSubview(cancel)
        
        let create = NSButton()
        create.image = NSImage(named:"button")
        create.target = self
        create.action = #selector(self.create)
        create.setButtonType(.momentaryChange)
        create.imageScaling = .scaleNone
        create.translatesAutoresizingMaskIntoConstraints = false
        create.isBordered = false
        create.attributedTitle = NSAttributedString(string:.local("NewView.create"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        create.keyEquivalent = "\r"
        contentView!.addSubview(create)
        
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
        none.title = String()
        contentView!.addSubview(none)
        self.none = none
        
        let single = NSButton()
        single.translatesAutoresizingMaskIntoConstraints = false
        single.image = NSImage(named:"singleOff")
        single.target = self
        single.action = #selector(selectSingle)
        single.isBordered = false
        single.imageScaling = .scaleNone
        single.title = String()
        contentView!.addSubview(single)
        self.single = single
        
        let double = NSButton()
        double.translatesAutoresizingMaskIntoConstraints = false
        double.image = NSImage(named:"doubleOff")
        double.target = self
        double.action = #selector(selectDouble)
        double.isBordered = false
        double.imageScaling = .scaleNone
        double.title = String()
        contentView!.addSubview(double)
        self.double = double
        
        let triple = NSButton()
        triple.translatesAutoresizingMaskIntoConstraints = false
        triple.image = NSImage(named:"tripleOff")
        triple.target = self
        triple.action = #selector(selectTriple)
        triple.isBordered = false
        triple.imageScaling = .scaleNone
        triple.title = String()
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
        
        cancel.leftAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:-185).isActive = true
        cancel.centerYAnchor.constraint(equalTo:create.centerYAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:92).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        create.rightAnchor.constraint(equalTo:contentView!.centerXAnchor, constant:160).isActive = true
        create.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor, constant:135).isActive = true
        create.widthAnchor.constraint(equalToConstant:92).isActive = true
        create.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        contentView!.layoutSubtreeIfNeeded()
        selectTriple()
    }
    
    func control(_:NSControl, textView:NSTextView, doCommandBy selector:Selector) -> Bool {
        if (selector == #selector(NSResponder.insertNewline(_:))) {
            makeFirstResponder(nil)
            create()
            return true
        }
        return false
    }
    
    private func moveSelector(_ left:CGFloat) {
        selectorLeft.constant = left
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.35
            context.allowsImplicitAnimation = true
            contentView!.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    @objc private func selectNone() {
        template = Template.none
        none.image = NSImage(named:"noneOn")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(-140)
        columns.stringValue = .local("NewView.none")
        makeFirstResponder(nil)
    }
    
    @objc private func selectSingle() {
        template = .single
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOn")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(-40)
        columns.stringValue = .local("NewView.single")
        makeFirstResponder(nil)
    }
    
    @objc private func selectDouble() {
        template = .double
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOn")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(40)
        columns.stringValue = .local("NewView.double")
        makeFirstResponder(nil)
    }
    
    @objc private func selectTriple() {
        template = .triple
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOn")
        moveSelector(140)
        columns.stringValue = .local("NewView.triple")
        makeFirstResponder(nil)
    }
    
    @objc private func cancel() {
        end()
    }
    
    @objc private func create() {
        let name = self.name.stringValue
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let template = self?.template else { return }
            Application.shared.view.repository.newBoard(name, template:template)
        }
        if Application.shared.view.repository.rate() {
            if #available(OSX 10.14, *) { SKStoreReviewController.requestReview() }
        }
        end()
    }
}
