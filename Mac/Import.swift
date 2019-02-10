import AppKit
import VelvetRoom

class Import:Sheet {
    @discardableResult override init() {
        super.init()
        let title = Label()
        title.attributedStringValue = {
            $0.append(NSAttributedString(string:.local("Import.title"), attributes:
                [.font:NSFont.systemFont(ofSize:16, weight:.bold)]))
            $0.append(NSAttributedString(string:.local("Import.description"), attributes:
                [.font:NSFont.systemFont(ofSize:16, weight:.ultraLight)]))
            return $0
        } (NSMutableAttributedString())
        addSubview(title)
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        image.image = NSImage(named:"dropOff")
        addSubview(image)
        
        let drop = Drop(image) { [weak self] in self?.selected($0) }
        addSubview(drop)
        
        let search = Button(.local("Import.open"))
        search.target = self
        search.action = #selector(open)
        search.keyEquivalent = "\r"
        addSubview(search)
        
        let cancel = Link(.local("Import.cancel"))
        cancel.target = self
        cancel.action = #selector(close)
        addSubview(cancel)
        
        drop.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        drop.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo:drop.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:drop.bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:drop.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:drop.rightAnchor).isActive = true
        
        title.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo:image.topAnchor, constant:-20).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant:400).isActive = true
        
        search.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        search.topAnchor.constraint(equalTo:image.bottomAnchor, constant:20).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:search.bottomAnchor, constant:20).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func selected(_ url:URL) {
        if let image = NSImage(byReferencing:url).cgImage(forProposedRect:nil, context:nil, hints:nil),
            let id = try? Sharer.load(image) {
            Repository.shared.load(id)
        } else {
            Alert.shared.add(Exception.imageNotValid)
        }
        close()
    }
    
    @objc private func open() {
        let browser = NSOpenPanel()
        browser.message = .local("Import.qr")
        browser.allowedFileTypes = ["png"]
        browser.begin { [weak self] result in
            if result == .OK {
                self?.selected(browser.url!)
            }
        }
    }
}
