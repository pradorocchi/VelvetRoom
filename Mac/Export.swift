import AppKit
import VelvetRoom

class Export:Sheet {
    private weak var board:Board!
    private weak var image:NSImage!
    
    @discardableResult init(_ board:Board) {
        super.init()
        self.board = board
        
        let title = Label(board.name, font:.systemFont(ofSize:20, weight:.bold))
        title.alignment = .center
        addSubview(title)
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyDown
        image.wantsLayer = true
        image.layer!.cornerRadius = 5
        addSubview(image)
        
        let share = Button(.local("Export.share"))
        share.target = self
        share.action = #selector(self.share)
        share.keyEquivalent = "\r"
        addSubview(share)
        
        let cancel = Link(.local("Export.cancel"))
        cancel.target = self
        cancel.action = #selector(close)
        addSubview(cancel)
        
        image.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:200).isActive = true
        image.heightAnchor.constraint(equalToConstant:200).isActive = true
        
        title.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo:image.topAnchor, constant:-20).isActive = true
        
        share.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        share.topAnchor.constraint(equalTo:image.bottomAnchor, constant:40).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:share.bottomAnchor, constant:20).isActive = true
        
        DispatchQueue.global(qos:.background).async {
            let cgImage = Sharer.export(board)
            DispatchQueue.main.async { [weak self] in
                image.image = NSImage(cgImage:cgImage, size:NSSize(width:cgImage.width, height:cgImage.height))
                self?.image = image.image
            }
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func share() {
        let save = NSSavePanel()
        save.message = .local("Export.qr")
        save.allowedFileTypes = ["png"]
        save.nameFieldStringValue = board.name
        save.begin { [weak self] result in
            if result == .OK {
                self?.saveTo(save.url!)
            }
        }
    }
    
    private func saveTo(_ url:URL) {
        let image = NSImage(size:NSSize(width:400, height:490))
        image.lockFocus()
        NSColor.white.drawSwatch(in:NSRect(x:0, y:0, width:400, height:490))
        (board.name as NSString).draw(in:NSRect(x:32, y:390, width:360, height:50), withAttributes:
            [.font:NSFont.systemFont(ofSize:30, weight:.bold), .foregroundColor:NSColor.black])
        self.image.draw(in:NSRect(x:20, y:20, width:360, height:360))
        image.unlockFocus()
        try! NSBitmapImageRep(data:image.tiffRepresentation!)?.representation(using:.png, properties:[:])!.write(to:url)
        close()
    }
}
