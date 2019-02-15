import UIKit
import VelvetRoom

class BoardItem:UIControl, UITextViewDelegate {
    override var isSelected:Bool { didSet { updateSkin() } }
    override var isHighlighted:Bool { didSet { updateSkin() } }
    private(set) weak var board:Board!
    private weak var text:Text!
    private weak var date:UILabel!
    private weak var delete:UIButton!
    private weak var export:UIButton!
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        
        let gesture = UILongPressGestureRecognizer(target:self, action:#selector(longpressed(_:)))
        gesture.minimumPressDuration = 1
        addGestureRecognizer(gesture)
        self.board = board
        
        let text = Text()
        text.font = .systemFont(ofSize:Skin.shared.font, weight:.bold)
        text.delegate = self
        text.text = board.name
        text.textContainer.maximumNumberOfLines = 1
        text.onDelete = { [weak self] in self?.remove() }
        addSubview(text)
        self.text = text
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .systemFont(ofSize:10, weight:.light)
        date.text = formatter.string(from:Date(timeIntervalSince1970:board.updated))
        addSubview(date)
        self.date = date
        
        let delete = UIButton()
        delete.addTarget(self, action:#selector(remove), for:.touchUpInside)
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        delete.imageView!.clipsToBounds = true
        delete.imageView!.contentMode = .center
        addSubview(delete)
        self.delete = delete
        
        let export = UIButton()
        export.addTarget(self, action:#selector(send), for:.touchUpInside)
        export.translatesAutoresizingMaskIntoConstraints = false
        export.setImage(#imageLiteral(resourceName: "export.pdf"), for:.normal)
        export.imageView!.clipsToBounds = true
        export.imageView!.contentMode = .center
        addSubview(export)
        self.export = export
        
        heightAnchor.constraint(equalToConstant:62).isActive = true
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-6).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        text.rightAnchor.constraint(equalTo:export.leftAnchor, constant:-10).isActive = true
        
        date.leftAnchor.constraint(equalTo:text.leftAnchor, constant:6).isActive = true
        date.topAnchor.constraint(equalTo:text.bottomAnchor, constant:-2).isActive = true
        
        delete.topAnchor.constraint(equalTo:topAnchor).isActive = true
        delete.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        delete.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        delete.widthAnchor.constraint(equalToConstant:54).isActive = true
        
        export.topAnchor.constraint(equalTo:topAnchor).isActive = true
        export.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        export.rightAnchor.constraint(equalTo:delete.leftAnchor).isActive = true
        export.widthAnchor.constraint(equalToConstant:54).isActive = true
        
        updateSkin()
        Skin.add(self)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func textViewDidEndEditing(_:UITextView) {
        text.isUserInteractionEnabled = false
        board.name = text.text
        text.text = board.name
        delete.isHidden = false
        export.isHidden = false
        Repository.shared.scheduleUpdate(board)
        updateSkin()
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText:String) -> Bool {
        if replacementText == "\n" {
            text.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func updateSkin() {
        if text.isFirstResponder {
            backgroundColor = .clear
            text.textColor = Skin.shared.text
            date.isHidden = true
        } else if isHighlighted || isSelected || List.shared.selected === self {
            backgroundColor = .velvetBlue
            text.textColor = .black
            date.textColor = .black
            date.isHidden = false
        } else {
            backgroundColor = Skin.shared.over
            text.textColor = Skin.shared.text
            date.textColor = Skin.shared.text
            date.isHidden = false
        }
    }
    
    @objc private func remove() {
        Delete {
            DispatchQueue.global(qos:.background).async { [weak self] in
                guard let board = self?.board else { return }
                Repository.shared.delete(board)
            }
        }
    }
    
    @objc private func send() { Export(board) }
    
    @objc private func longpressed(_ gesture:UILongPressGestureRecognizer) {
        guard
            gesture.state == .began,
            gesture.location(in:self).x < bounds.width - 80
        else { return }
        delete.isHidden = true
        export.isHidden = true
        text.isUserInteractionEnabled = true
        text.becomeFirstResponder()
        updateSkin()
    }
}
