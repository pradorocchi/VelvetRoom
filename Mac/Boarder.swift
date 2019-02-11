import AppKit
import VelvetRoom
import StoreKit

class Boarder:Sheet, NSTextViewDelegate {
    private weak var text:Text!
    private weak var columns:Label!
    private weak var none:NSButton!
    private weak var single:NSButton!
    private weak var double:NSButton!
    private weak var triple:NSButton!
    private weak var selectorLeft:NSLayoutConstraint!
    private var template:Template!
    
    @discardableResult override init() {
        super.init()
        let title = Label(.local("Boarder.title"), font:.systemFont(ofSize:20, weight:.bold))
        addSubview(title)
        
        let columns = Label(font:.systemFont(ofSize:15, weight:.light))
        columns.alphaValue = 0.7
        addSubview(columns)
        self.columns = columns
        
        let text = Text()
        text.textContainer!.size = NSSize(width:310, height:40)
        text.font = .light(18)
        text.isEditable = true
        text.delegate = self
        addSubview(text)
        self.text = text
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor(white:1, alpha:0.4).cgColor
        addSubview(border)
        
        let cancel = Link(.local("Boarder.cancel"))
        cancel.target = self
        cancel.action = #selector(close)
        addSubview(cancel)
        
        let create = Button(.local("Boarder.create"))
        create.target = self
        create.action = #selector(self.create)
        create.keyEquivalent = "\r"
        addSubview(create)
        
        let selector = NSView()
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.wantsLayer = true
        selector.layer!.backgroundColor = NSColor.velvetBlue.cgColor
        selector.layer!.cornerRadius = 4
        addSubview(selector)
        
        let none = NSButton()
        none.translatesAutoresizingMaskIntoConstraints = false
        none.image = NSImage(named:"noneOff")
        none.target = self
        none.action = #selector(selectNone)
        none.isBordered = false
        none.imageScaling = .scaleNone
        none.title = String()
        addSubview(none)
        self.none = none
        
        let single = NSButton()
        single.translatesAutoresizingMaskIntoConstraints = false
        single.image = NSImage(named:"singleOff")
        single.target = self
        single.action = #selector(selectSingle)
        single.isBordered = false
        single.imageScaling = .scaleNone
        single.title = String()
        addSubview(single)
        self.single = single
        
        let double = NSButton()
        double.translatesAutoresizingMaskIntoConstraints = false
        double.image = NSImage(named:"doubleOff")
        double.target = self
        double.action = #selector(selectDouble)
        double.isBordered = false
        double.imageScaling = .scaleNone
        double.title = String()
        addSubview(double)
        self.double = double
        
        let triple = NSButton()
        triple.translatesAutoresizingMaskIntoConstraints = false
        triple.image = NSImage(named:"tripleOff")
        triple.target = self
        triple.action = #selector(selectTriple)
        triple.isBordered = false
        triple.imageScaling = .scaleNone
        triple.title = String()
        addSubview(triple)
        self.triple = triple
        
        title.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo:border.topAnchor, constant:-120).isActive = true
        
        text.leftAnchor.constraint(equalTo:border.leftAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo:border.topAnchor, constant:-10).isActive = true
        
        border.bottomAnchor.constraint(equalTo:centerYAnchor, constant:-80).isActive = true
        border.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant:320).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        selector.widthAnchor.constraint(equalToConstant:44).isActive = true
        selector.heightAnchor.constraint(equalToConstant:44).isActive = true
        selector.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        selectorLeft = selector.centerXAnchor.constraint(equalTo:centerXAnchor, constant:-160)
        selectorLeft.isActive = true
        
        none.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        none.leftAnchor.constraint(equalTo:centerXAnchor, constant:-180).isActive = true
        none.widthAnchor.constraint(equalToConstant:80).isActive = true
        none.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        single.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        single.leftAnchor.constraint(equalTo:none.rightAnchor, constant:20).isActive = true
        single.widthAnchor.constraint(equalToConstant:80).isActive = true
        single.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        double.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        double.leftAnchor.constraint(equalTo:single.rightAnchor).isActive = true
        double.widthAnchor.constraint(equalToConstant:80).isActive = true
        double.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        triple.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        triple.leftAnchor.constraint(equalTo:double.rightAnchor, constant:20).isActive = true
        triple.widthAnchor.constraint(equalToConstant:80).isActive = true
        triple.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        columns.leftAnchor.constraint(equalTo:centerXAnchor, constant:-160).isActive = true
        columns.topAnchor.constraint(equalTo:border.bottomAnchor, constant:160).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:centerXAnchor, constant:-180).isActive = true
        cancel.centerYAnchor.constraint(equalTo:title.centerYAnchor).isActive = true
        
        create.rightAnchor.constraint(equalTo:border.rightAnchor).isActive = true
        create.centerYAnchor.constraint(equalTo:title.centerYAnchor).isActive = true
        
        layoutSubtreeIfNeeded()
        selectTriple()
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {
            Window.shared.makeFirstResponder(text)
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        if with.clickCount == 2 {
            text.isEditable = true
            Window.shared.makeFirstResponder(text)
        }
    }
    
    func textView(_:NSTextView, doCommandBy:Selector) -> Bool {
        if (doCommandBy == #selector(NSResponder.insertNewline(_:))) {
            Window.shared.makeFirstResponder(nil)
            create()
            return true
        }
        return false
    }
    
    func textDidEndEditing(_:Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.text.string.isEmpty {
                self.text.string = .local("Boarder.placeholder")
            }
            Window.shared.makeFirstResponder(self)
        }
    }
    
    private func moveSelector(_ left:CGFloat) {
        selectorLeft.constant = left
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.35
            context.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    @objc private func selectNone() {
        template = Template.none
        none.image = NSImage(named:"noneOn")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(-140)
        columns.stringValue = .local("Boarder.none")
        Window.shared.makeFirstResponder(nil)
    }
    
    @objc private func selectSingle() {
        template = .single
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOn")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(-40)
        columns.stringValue = .local("Boarder.single")
        Window.shared.makeFirstResponder(nil)
    }
    
    @objc private func selectDouble() {
        template = .double
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOn")
        triple.image = NSImage(named:"tripleOff")
        moveSelector(40)
        columns.stringValue = .local("Boarder.double")
        Window.shared.makeFirstResponder(nil)
    }
    
    @objc private func selectTriple() {
        template = .triple
        none.image = NSImage(named:"noneOff")
        single.image = NSImage(named:"singleOff")
        double.image = NSImage(named:"doubleOff")
        triple.image = NSImage(named:"tripleOn")
        moveSelector(140)
        columns.stringValue = .local("Boarder.triple")
        Window.shared.makeFirstResponder(nil)
    }
    
    @objc private func create() {
        let name = text.string
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let template = self?.template else { return }
            Repository.shared.newBoard(name, template:template)
        }
        if #available(OSX 10.14, *), Repository.shared.rate() { SKStoreReviewController.requestReview() }
        close()
    }
}
