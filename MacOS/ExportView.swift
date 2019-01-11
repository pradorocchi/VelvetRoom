import AppKit
import VelvetRoom

class ExportView:SheetView {
    private weak var board:Board!
    private weak var image:NSImage!
    
    init(_ board:Board) {
        super.init()
        self.board = board
        
        let done = NSButton()
        done.target = self
        done.action = #selector(self.end)
        done.image = NSImage(named:"delete")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.font = .systemFont(ofSize:16, weight:.bold)
        done.keyEquivalent = "\u{1b}"
        contentView!.addSubview(done)
        
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(string:.local("ExportView.title"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.bold), .foregroundColor:NSColor.velvetBlue]))
        mutable.append(NSAttributedString(string:board.name, attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.bold), .foregroundColor:NSColor.white]))
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.attributedStringValue = mutable
        contentView!.addSubview(title)
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyDown
        image.wantsLayer = true
        image.layer!.cornerRadius = 5
        contentView!.addSubview(image)
        
        let share = NSButton()
        share.image = NSImage(named:"button")
        share.target = self
        share.action = #selector(self.share)
        share.setButtonType(.momentaryChange)
        share.imageScaling = .scaleNone
        share.translatesAutoresizingMaskIntoConstraints = false
        share.isBordered = false
        share.attributedTitle = NSAttributedString(string:.local("ExportView.share"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        share.keyEquivalent = "\r"
        contentView!.addSubview(share)
        
        image.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:200).isActive = true
        image.heightAnchor.constraint(equalToConstant:200).isActive = true
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.topAnchor.constraint(equalTo:done.topAnchor).isActive = true
        
        share.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        share.topAnchor.constraint(equalTo:image.bottomAnchor, constant:40).isActive = true
        share.widthAnchor.constraint(equalToConstant:92).isActive = true
        share.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        DispatchQueue.global(qos:.background).async {
            let cgImage = Sharer.export(board)
            DispatchQueue.main.async { [weak self] in
                image.image = NSImage(cgImage:cgImage, size:NSSize(width:cgImage.width, height:cgImage.height))
                self?.image = image.image
            }
        }
    }
    
    @objc private func share() {
        let save = NSSavePanel()
        save.message = .local("ExportView.qr")
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
        end()
    }
}
