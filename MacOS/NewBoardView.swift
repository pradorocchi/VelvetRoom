import AppKit

class NewBoardView:NSWindow {
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
    }
    
    @objc private func cancel() {
        Application.view.endSheet(self, returnCode:.cancel)
    }
    
    @objc private func delete() {
        Application.view.endSheet(self, returnCode:.continue)
    }
}
