import AppKit
import VelvetRoom

class ImportView:SheetView {
    override init() {
        super.init()
        
        let done = NSButton()
        done.target = self
        done.action = #selector(end)
        done.image = NSImage(named:"close")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.keyEquivalent = "\u{1b}"
        done.title = String()
        contentView!.addSubview(done)
        
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(string:.local("ImportView.title"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.bold), .foregroundColor:NSColor.velvetBlue]))
        mutable.append(NSAttributedString(string:.local("ImportView.description"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.ultraLight), .foregroundColor:NSColor.white]))
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.attributedStringValue = mutable
        contentView!.addSubview(title)
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        image.image = NSImage(named:"dropOff")
        contentView!.addSubview(image)
        
        let drop = DropView(image)
        drop.selected = selected
        contentView!.addSubview(drop)
        
        let openButton = NSButton()
        openButton.image = NSImage(named:"button")
        openButton.target = self
        openButton.action = #selector(open)
        openButton.setButtonType(.momentaryChange)
        openButton.imageScaling = .scaleNone
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.isBordered = false
        openButton.attributedTitle = NSAttributedString(string:.local("ImportView.open"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        openButton.keyEquivalent = "\r"
        contentView!.addSubview(openButton)
        
        drop.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        drop.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        drop.widthAnchor.constraint(equalToConstant:120).isActive = true
        drop.heightAnchor.constraint(equalToConstant:120).isActive = true
        
        image.topAnchor.constraint(equalTo:drop.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:drop.bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:drop.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:drop.rightAnchor).isActive = true
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:24).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.topAnchor.constraint(equalTo:done.topAnchor).isActive = true
        
        openButton.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        openButton.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        openButton.widthAnchor.constraint(equalToConstant:92).isActive = true
        openButton.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    private func selected(_ url:URL) {
        if let image = NSImage(byReferencing:url).cgImage(forProposedRect:nil, context:nil, hints:nil),
            let id = try? Sharer.load(image) {
            Application.shared.view.repository.load(id)
        } else {
            Application.shared.view.alert.add(Exception.imageNotValid)
        }
        end()
    }
    
    @objc private func open() {
        let browser = NSOpenPanel()
        browser.message = .local("ImportView.qr")
        browser.allowedFileTypes = ["png"]
        browser.begin { [weak self] result in
            if result == .OK {
                self?.selected(browser.url!)
            }
        }
    }
}
