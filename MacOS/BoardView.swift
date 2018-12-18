import AppKit
import VelvetRoom

class BoardView:NSControl {
    private(set) var board:Board!
    private weak var name:NSTextField!
    var selected = false { didSet { update() } }
    
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:50) }
    
    init(_ board:Board) {
        self.board = board
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let name = NSTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        name.isBezeled = false
        name.isEditable = false
        name.font = .systemFont(ofSize:16, weight:.medium)
        name.maximumNumberOfLines = 1
        name.stringValue = board.name
        addSubview(name)
        self.name = name
        
        name.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func mouseDown(with:NSEvent) {
        if !selected {
            sendAction(action, to:target)
        }
    }
    
    private func update() {
        if selected {
            layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            name.alphaValue = 0.7
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            name.alphaValue = 0.4
        }
    }
}
