import UIKit
import VelvetRoom

class BoardView:UIControl, UITextViewDelegate {
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    private(set) weak var board:Board!
    private weak var text:TextView!
    private weak var delete:UIButton!
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:54) }
    
    init(_ board:Board) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        addTarget(self, action:#selector(selectBoard), for:.touchUpInside)
        let gesture = UILongPressGestureRecognizer(target:self, action:#selector(longpressed(_:)))
        gesture.minimumPressDuration = 1
        addGestureRecognizer(gesture)
        self.board = board
        
        let text = TextView()
        text.font = .regular(18)
        text.delegate = self
        text.text = board.name
        text.bounces = false
        text.isScrollEnabled = false
        text.isUserInteractionEnabled = false
        text.textContainer.maximumNumberOfLines = 1
        text.textContainer.lineBreakMode = .byTruncatingTail
        addSubview(text)
        self.text = text
        
        let delete = UIButton()
        delete.addTarget(self, action:#selector(remove), for:.touchUpInside)
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        delete.imageView!.clipsToBounds = true
        delete.imageView!.contentMode = .center
        addSubview(delete)
        self.delete = delete
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:12).isActive = true
        text.rightAnchor.constraint(equalTo:delete.leftAnchor, constant:-10).isActive = true
        text.heightAnchor.constraint(equalToConstant:22).isActive = true
        
        delete.topAnchor.constraint(equalTo:topAnchor).isActive = true
        delete.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        delete.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        delete.widthAnchor.constraint(equalToConstant:54).isActive = true
        
        update()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textViewDidEndEditing(_:UITextView) {
        delete.isHidden = false
        text.isUserInteractionEnabled = false
        board.name = text.text
        Application.view.scheduleUpdate(board)
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText string:String) -> Bool {
        if string == "\n" {
            text.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func update() {
        if text.isFirstResponder {
            backgroundColor = .clear
            text.textColor = .white
        } else if isHighlighted || isSelected {
            backgroundColor = .velvetBlue
            text.textColor = .black
        } else {
            backgroundColor = .velvetShade
            text.textColor = .white
        }
    }
    
    @objc private func remove() {
        UIApplication.shared.keyWindow!.endEditing(true)
        Application.view.present(DeleteView {
            DispatchQueue.global(qos:.background).async {
                Application.view.repository.delete(self.board)
            }
        }, animated:true)
    }
    
    @objc private func selectBoard() {
        guard !text.isFirstResponder else { return }
        UIApplication.shared.keyWindow!.endEditing(true)
        isHighlighted = true
        isSelected = true
        Application.view.open(board)
        DispatchQueue.main.asyncAfter(deadline:.now() + 1) { [weak self] in
            self?.isSelected = false
        }
    }
    
    @objc private func longpressed(_ gesture:UILongPressGestureRecognizer) {
        guard
            gesture.state == .began,
            gesture.location(in:self).x < bounds.width - 80
        else { return }
        delete.isHidden = true
        text.isUserInteractionEnabled = true
        text.becomeFirstResponder()
        update()
    }
}
