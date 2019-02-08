import AppKit
import VelvetRoom

class BoardView:NSView, NSTextViewDelegate {
    var selected = false { didSet { updateSkin() } }
    var selector:Selector!
    private(set) weak var board:Board!
    private weak var date:NSTextField!
    private weak var text:Text!
    private let dateFormatter = DateFormatter()
    override var intrinsicContentSize:NSSize { return NSSize(width:NSView.noIntrinsicMetric, height:85) }
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        self.board = board
        
        let text = Text()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        let date = NSTextField()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.backgroundColor = .clear
        date.isBezeled = false
        date.isEditable = false
        date.font = .systemFont(ofSize:10, weight:.light)
        addSubview(date)
        self.date = date
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-8).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        
        date.topAnchor.constraint(equalTo:text.bottomAnchor, constant:-1).isActive = true
        date.leftAnchor.constraint(equalTo:text.leftAnchor, constant:4).isActive = true
        
        Skin.add(self, selector:#selector(updateSkin))
        updateSkin()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func mouseDown(with event:NSEvent) {
        if event.clickCount == 2 {
            text.isEditable = true
            Window.shared.makeFirstResponder(text)
            updateSkin()
        } else if !selected {
            perform(selector, with:List.shared)
        }
    }
    
    func delete() {
        Window.shared.makeFirstResponder(nil)
        Window.shared.beginSheet(DeleteView(.local("DeleteView.board")) { [weak self] in
            guard let board = self?.board else { return }
            Repository.shared.delete(board)
        })
    }
    
    func textDidEndEditing(_:Notification) {
        board.name = text.string
        if board.name.isEmpty {
            delete()
        } else {
            text.string = board.name
        }
        List.shared.scheduleUpdate(board)
        DispatchQueue.main.async { [weak self] in self?.updateSkin() }
    }
    
    func textView(_:NSTextView, doCommandBy command:Selector) -> Bool {
        if (command == #selector(NSResponder.insertNewline(_:))) {
            Window.shared.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    @objc private func updateSkin() {
        text.textColor = Skin.shared.text
        date.textColor = Skin.shared.text
        date.stringValue = dateFormatter.string(from:Date(timeIntervalSince1970:board.updated))
        if Window.shared.firstResponder === text {
            layer!.backgroundColor = .black
            text.textColor = .white
            text.alphaValue = 1
            date.alphaValue = 0
        } else if selected {
            layer!.backgroundColor = Skin.shared.text.withAlphaComponent(0.2).cgColor
            text.alphaValue = 0.8
            date.alphaValue = 0.8
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            text.alphaValue = 0.8
            date.alphaValue = 0.8
        }
        text.setNeedsDisplay(text.bounds)
        text.textContainer!.size = NSSize(width:235, height:Skin.shared.font + 16)
        text.font = .bold(Skin.shared.font)
        text.string = board.name
    }
}
