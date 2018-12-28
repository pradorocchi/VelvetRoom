import AppKit
import VelvetRoom

class ChartView:NSWindow {
    override var canBecomeKey:Bool { return true }
    
    init(_ board:Board) {
        super.init(contentRect:NSRect(x:0, y:0, width:Application.shared.view.frame.width - 2, height:
            Application.shared.view.frame.height - 2), styleMask:[], backing:.buffered, defer:false)
        isOpaque = false
        backgroundColor = .clear
        contentView!.wantsLayer = true
        contentView!.layer!.backgroundColor = NSColor.black.cgColor
        contentView!.layer!.cornerRadius = 4
        
        let done = NSButton()
        done.target = self
        done.action = #selector(self.done)
        done.image = NSImage(named:"delete")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.font = .systemFont(ofSize:16, weight:.bold)
        done.keyEquivalent = "\u{1b}"
        contentView!.addSubview(done)
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:16, weight:.bold)
        title.textColor = .velvetBlue
        title.stringValue = board.name
        contentView!.addSubview(title)
        
        let cross = CrossView(board.chart)
        contentView!.addSubview(cross)
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.centerYAnchor.constraint(equalTo:done.centerYAnchor).isActive = true
        
        cross.topAnchor.constraint(equalTo:contentView!.topAnchor).isActive = true
        cross.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor).isActive = true
        cross.leftAnchor.constraint(equalTo:contentView!.leftAnchor).isActive = true
        cross.rightAnchor.constraint(equalTo:contentView!.rightAnchor).isActive = true
    }
    
    @objc private func done() {
        Application.shared.view.endSheet(self)
    }
}
