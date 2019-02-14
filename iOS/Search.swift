import UIKit

class Search:UIView, UITextViewDelegate {
    static let shared = Search()
    weak var bottom:NSLayoutConstraint! { didSet { bottom.isActive = true } }
    private weak var text:Text!
    private weak var highlighter:UIView?
    
    private init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        layer.cornerRadius = 12
        
        let image = UIImageView(image:#imageLiteral(resourceName: "searchIcon.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        image.clipsToBounds = true
        addSubview(image)
        
        let text = Text()
        text.font = .light(22)
        text.delegate = self
        text.deleteButton.isHidden = true
        self.text = text
        addSubview(text)
        
        heightAnchor.constraint(equalToConstant:60).isActive = true
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:50).isActive = true
        
        text.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo:image.rightAnchor).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        text.heightAnchor.constraint(equalToConstant:34).isActive = true
        
        Skin.add(self)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textViewDidEndEditing(_:UITextView) {
        unactive()
    }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText:String) -> Bool {
        if replacementText == "\n" {
            text.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_:UITextView) {
        if self.highlighter == nil {
            let highlighter = UIView()
            highlighter.backgroundColor = .velvetBlue
            highlighter.layer.cornerRadius = 4
            Canvas.shared.addSubview(highlighter)
            Canvas.shared.sendSubviewToBack(highlighter)
            self.highlighter = highlighter
        }
        highlighter!.frame = .zero
        for v in Canvas.shared.content.subviews.compactMap( { $0 as? Edit } )  {
            if let range = v.text.text.range(of:text.text, options:.caseInsensitive) {
                var frame = Canvas.shared.content.convert(v.text.layoutManager.boundingRect(
                    forGlyphRange:NSRange(range, in:v.text.text), in:v.text.textContainer), from:v.text)
                frame.origin.x -= 10
                frame.size.width += 20
                highlighter!.frame = frame
                frame.origin.x -= (App.shared.frame.width - frame.size.width) / 2
                frame.origin.y -= App.shared.frame.midY
                frame.size.width = App.shared.frame.width
                frame.size.height = App.shared.frame.height
                Canvas.shared.scrollRectToVisible(frame, animated:true)
                break
            }
        }
    }
    
    @objc func active() {
        UIApplication.shared.keyWindow!.endEditing(true)
        bottom.constant = 120 + App.shared.margin.top
        text.isEditable = true
        UIView.animate(withDuration:0.4, animations: {
            self.superview!.layoutIfNeeded()
        }) { _ in
            self.text.becomeFirstResponder()
        }
    }
    
    private func unactive() {
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
        backgroundColor = Skin.shared.text.withAlphaComponent(0.96)
        text.textColor = Skin.shared.background
    }
}
