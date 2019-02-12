import AppKit
import VelvetRoom

class BoardItem:NSView, NSTextViewDelegate {
    var selector:Selector!
    private(set) weak var board:Board!
    private weak var date:Label!
    private weak var text:Text!
    private let dater = DateFormatter()
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.cornerRadius = 6
        dater.timeStyle = .short
        dater.dateStyle = .short
        self.board = board
        
        let text = Text()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        let date = Label(font:.systemFont(ofSize:10, weight:.light))
        addSubview(date)
        self.date = date
        
        heightAnchor.constraint(equalToConstant:85).isActive = true
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-8).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        
        date.topAnchor.constraint(equalTo:text.bottomAnchor, constant:-1).isActive = true
        date.leftAnchor.constraint(equalTo:text.leftAnchor, constant:4).isActive = true
        
        updateSkin()
        Skin.add(self)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func mouseDown(with:NSEvent) {
        if with.clickCount == 2 {
            text.isEditable = true
            Window.shared.makeFirstResponder(text)
            updateSkin()
        } else if List.shared.selected !== self {
            List.shared.perform(selector, with:self)
        }
    }
    
    func delete() {
        Delete(board.name.isEmpty ? .local("BoardView.delete") : board.name) { [weak self] in
            guard let board = self?.board else { return }
            Repository.shared.delete(board)
        }
    }
    
    func textDidEndEditing(_:Notification) {
        board.name = text.string
        if board.name.isEmpty {
            delete()
        } else {
            text.string = board.name
        }
        Repository.shared.scheduleUpdate(board)
        DispatchQueue.main.async { [weak self] in self?.updateSkin() }
    }
    
    func textView(_:NSTextView, doCommandBy:Selector) -> Bool {
        if (doCommandBy == #selector(NSResponder.insertNewline(_:))) {
            Window.shared.makeFirstResponder(nil)
            return true
        }
        return false
    }
    
    @objc func updateSkin() {
        guard let board = self.board else { return }
        text.textColor = Skin.shared.text
        date.textColor = Skin.shared.text
        let last = Date(timeIntervalSince1970:board.updated)
        dater.dateStyle = Calendar.current.dateComponents([.day], from:last, to:Date()).day! == 0 ? .none : .short
        date.stringValue = dater.string(from:last)
        if Window.shared.firstResponder === text {
            layer!.backgroundColor = .black
            text.textColor = .white
            text.alphaValue = 1
            date.alphaValue = 0
        } else if List.shared.selected === self {
            layer!.backgroundColor = Skin.shared.text.withAlphaComponent(0.2).cgColor
            text.alphaValue = 0.9
            date.alphaValue = 0.9
        } else {
            layer!.backgroundColor = NSColor.clear.cgColor
            text.alphaValue = 0.5
            date.alphaValue = 0.5
        }
        text.setNeedsDisplay(text.bounds)
        text.textContainer!.size = NSSize(width:235, height:Skin.shared.font + 16)
        text.font = .bold(Skin.shared.font)
        text.string = board.name
    }
}
