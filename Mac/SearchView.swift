import AppKit

class SearchView:NSView {
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
        field.font = .light(22)
        field.string = "hello world"
        field.update()
        self.field = field
        addSubview(field)
        
        widthAnchor.constraint(equalToConstant:450).isActive = true
        heightAnchor.constraint(equalToConstant:60).isActive = true
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor, constant:4).isActive = true
        image.widthAnchor.constraint(equalToConstant:36).isActive = true
        
        field.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        field.leftAnchor.constraint(equalTo:image.rightAnchor).isActive = true
        
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
    
    private func updateSkin() {
        layer!.backgroundColor = Application.skin.background.cgColor
        layer!.borderColor = Application.skin.text.withAlphaComponent(0.3).cgColor
    }
}
