import UIKit

class SearchView:UIView, UITextViewDelegate {
    private(set) weak var text:TextView!
    private(set) weak var highlighter:UIView?
    private weak var bottom:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        layer.borderWidth = 1
        
        let image = UIImageView(image:#imageLiteral(resourceName: "searchIcon.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
        
        let text = TextView()
        text.font = .light(22)
        text.delegate = self
        text.deleteButton.isHidden = true
        self.text = text
        addSubview(text)
        
        let done = UIButton()
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(self, action:#selector(self.done), for:.touchUpInside)
        done.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        done.imageView!.contentMode = .center
        done.imageView!.clipsToBounds = true
        addSubview(done)
        
        heightAnchor.constraint(equalToConstant:64).isActive = true
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:50).isActive = true
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:image.rightAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:done.leftAnchor).isActive = true
        text.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        done.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        done.widthAnchor.constraint(equalToConstant:50).isActive = true
        done.topAnchor.constraint(equalTo:topAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        updateSkin()
        Skin.add(self, selector:#selector(updateSkin))
    }
    
    required init?(coder:NSCoder) { return nil }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        bottom = bottomAnchor.constraint(equalTo:superview!.topAnchor)
        bottom.isActive = true
    }
    
    func textViewDidBeginEditing(_:UITextView) {
        if self.highlighter == nil {
//            let highlighter = NSView()
//            highlighter.wantsLayer = true
//            highlighter.layer!.backgroundColor = NSColor.velvetBlue.cgColor
//            highlighter.layer!.cornerRadius = 4
//            Application.view.canvas.contentView.addSubview(highlighter, positioned:.below, relativeTo:nil)
//            self.highlighter = highlighter
        }
    }
    
    func textViewDidEndEditing(_:UITextView) {
        unactive()
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText text:String) -> Bool {
        if text == "\n" {
            self.text.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_:UITextView) {
//        var range:Range<String.Index>!
//        guard let view = Application.view.canvas.documentView!.subviews.first (where: {
//            guard
//                let view = $0 as? EditView,
//                let textRange = view.text.string.range(of:text.string, options:.caseInsensitive)
//                else { return false }
//            range = textRange
//            return true
//        }) as? EditView else { return highlighter!.frame = .zero }
//        var frame = Application.view.canvas.contentView.convert(view.text.layoutManager!.boundingRect(forGlyphRange:
//            NSRange(range, in:view.text.string), in:view.text.textContainer!), from:view.text)
//        frame.origin.x -= 8
//        frame.size.width += 16
//        highlighter!.frame = frame
//        frame.origin.x -= Application.view.contentView!.bounds.midX
//        frame.origin.y -= Application.view.contentView!.bounds.midY
//        frame.size.width = Application.view.contentView!.bounds.width
//        frame.size.height = Application.view.contentView!.bounds.height
//        Application.view.canvas.contentView.scrollToVisible(frame)
    }
    
    func active() {
        bottom.constant = 120
        text.isEditable = true
        UIView.animate(withDuration:0.4, animations: {
            self.superview!.layoutIfNeeded()
        }) { _ in
            self.text.becomeFirstResponder()
        }
    }
    
    func unactive() {
        bottom.constant = 0
        text.isEditable = false
        UIView.animate(withDuration:0.6, animations: {
            self.highlighter?.alpha = 0
            self.superview!.layoutIfNeeded()
        }) { _ in
            self.highlighter?.removeFromSuperview()
            self.text.text = String()
        }
    }
    
    @objc private func updateSkin() {
        layer.backgroundColor = Application.skin.background.withAlphaComponent(0.85).cgColor
        layer.borderColor = Application.skin.text.withAlphaComponent(0.4).cgColor
        text.textColor = Application.skin.text
    }
    
    @objc private func done() {
        text.resignFirstResponder()
    }
}
