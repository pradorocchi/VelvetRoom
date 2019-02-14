import UIKit
import VelvetRoom
import StoreKit

class Boarder:Sheet, UITextViewDelegate {
    private weak var text:Text!
    private weak var none:UIButton!
    private weak var single:UIButton!
    private weak var double:UIButton!
    private weak var triple:UIButton!
    private weak var columns:UILabel!
    private weak var selector:UIView!
    private weak var centric:NSLayoutConstraint? { willSet { centric?.isActive = false; newValue?.isActive = true } }
    private var template = Template.none
    
    override init() {
        super.init()
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.textColor = Skin.shared.text
        labelTitle.font = .systemFont(ofSize:18, weight:.bold)
        labelTitle.text = .local("Boarder.title")
        labelTitle.textAlignment = .center
        addSubview(labelTitle)
        
        let text = Text()
        text.font = .systemFont(ofSize:Skin.shared.font + 10, weight:.bold)
        text.delegate = self
        text.textContainer.maximumNumberOfLines = 1
        text.isUserInteractionEnabled = true
        addSubview(text)
        self.text = text
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = Skin.shared.text.withAlphaComponent(0.2)
        addSubview(border)
        
        let cancel = Link(.local("Boarder.cancel"), target:self, selector:#selector(close))
        cancel.backgroundColor = Skin.shared.text.withAlphaComponent(0.1)
        cancel.setTitleColor(Skin.shared.text.withAlphaComponent(0.6), for:.normal)
        cancel.setTitleColor(Skin.shared.text.withAlphaComponent(0.15), for:.highlighted)
        addSubview(cancel)
        
        let create = Link(.local("Boarder.create"), target:self, selector:#selector(self.create))
        addSubview(create)
        
        let selector = UIView()
        selector.isUserInteractionEnabled = false
        selector.backgroundColor = .velvetBlue
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.layer.cornerRadius = 4
        addSubview(selector)
        self.selector = selector
        
        let none = UIButton()
        none.addTarget(self, action:#selector(selectNone), for:.touchUpInside)
        none.translatesAutoresizingMaskIntoConstraints = false
        none.setImage(#imageLiteral(resourceName: "none.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        none.imageView!.clipsToBounds = true
        none.imageView!.contentMode = .center
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        addSubview(none)
        self.none = none
        
        let single = UIButton()
        single.addTarget(self, action:#selector(selectSingle), for:.touchUpInside)
        single.translatesAutoresizingMaskIntoConstraints = false
        single.setImage(#imageLiteral(resourceName: "single.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        single.imageView!.clipsToBounds = true
        single.imageView!.contentMode = .center
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        addSubview(single)
        self.single = single
        
        let double = UIButton()
        double.addTarget(self, action:#selector(selectDouble), for:.touchUpInside)
        double.translatesAutoresizingMaskIntoConstraints = false
        double.setImage(#imageLiteral(resourceName: "double.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        double.imageView!.clipsToBounds = true
        double.imageView!.contentMode = .center
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        addSubview(double)
        self.double = double
        
        let triple = UIButton()
        triple.addTarget(self, action:#selector(selectTriple), for:.touchUpInside)
        triple.translatesAutoresizingMaskIntoConstraints = false
        triple.setImage(#imageLiteral(resourceName: "triple.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        triple.imageView!.clipsToBounds = true
        triple.imageView!.contentMode = .center
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        addSubview(triple)
        self.triple = triple
        
        let columns = UILabel()
        columns.translatesAutoresizingMaskIntoConstraints = false
        columns.font = .systemFont(ofSize:12, weight:.light)
        columns.textColor = Skin.shared.text
        columns.text = " "
        addSubview(columns)
        self.columns = columns
        
        labelTitle.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo:labelTitle.bottomAnchor, constant:30).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        text.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        border.leftAnchor.constraint(equalTo:text.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:text.rightAnchor).isActive = true
        border.topAnchor.constraint(equalTo:text.bottomAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        cancel.centerYAnchor.constraint(equalTo:labelTitle.centerYAnchor).isActive  = true
        
        create.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        create.centerYAnchor.constraint(equalTo:labelTitle.centerYAnchor).isActive = true
        
        selector.widthAnchor.constraint(equalToConstant:44).isActive = true
        selector.heightAnchor.constraint(equalToConstant:44).isActive = true
        selector.centerYAnchor.constraint(equalTo:none.centerYAnchor).isActive = true
        centric = selector.centerXAnchor.constraint(equalTo:triple.centerXAnchor)
        centric!.isActive = true
        
        none.topAnchor.constraint(equalTo:border.bottomAnchor, constant:30).isActive = true
        none.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        none.heightAnchor.constraint(equalToConstant:44).isActive = true
        none.widthAnchor.constraint(equalTo:widthAnchor, multiplier:0.25).isActive = true
        
        single.topAnchor.constraint(equalTo:none.topAnchor).isActive = true
        single.leftAnchor.constraint(equalTo:none.rightAnchor).isActive = true
        single.heightAnchor.constraint(equalToConstant:44).isActive = true
        single.widthAnchor.constraint(equalTo:widthAnchor, multiplier:0.25).isActive = true
        
        double.topAnchor.constraint(equalTo:none.topAnchor).isActive = true
        double.leftAnchor.constraint(equalTo:single.rightAnchor).isActive = true
        double.heightAnchor.constraint(equalToConstant:44).isActive = true
        double.widthAnchor.constraint(equalTo:widthAnchor, multiplier:0.25).isActive = true
        
        triple.topAnchor.constraint(equalTo:none.topAnchor).isActive = true
        triple.leftAnchor.constraint(equalTo:double.rightAnchor).isActive = true
        triple.heightAnchor.constraint(equalToConstant:44).isActive = true
        triple.widthAnchor.constraint(equalTo:widthAnchor, multiplier:0.25).isActive = true
        
        columns.topAnchor.constraint(equalTo:none.bottomAnchor, constant:20).isActive = true
        columns.leftAnchor.constraint(equalTo:border.leftAnchor).isActive = true
        columns.widthAnchor.constraint(equalToConstant:200).isActive = true
        columns.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        if #available(iOS 11.0, *) {
            labelTitle.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor, constant:20).isActive = true
        } else {
            labelTitle.topAnchor.constraint(equalTo:topAnchor, constant:20).isActive = true
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func textView(_:UITextView, shouldChangeTextIn:NSRange, replacementText:String) -> Bool {
        if replacementText == "\n" {
            text.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_:UITextView) {
        if text.text.isEmpty {
            text.text = .local("Boarder.placeholder")
        }
    }
    
    override func ready() {
        selectTriple()
        text.becomeFirstResponder()
    }
    
    private func moveSelector(_ view:UIView) {
        centric = selector.centerXAnchor.constraint(equalTo:view.centerXAnchor)
        UIView.animate(withDuration:0.3) { [weak self] in self?.layoutIfNeeded() }
    }
    
    @objc private func create() {
        text.resignFirstResponder()
        let name = text.text!
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let template = self?.template else { return }
            Repository.shared.newBoard(name, template:template)
        }
        if Repository.shared.rate() { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
        close()
    }
    
    @objc private func selectNone() {
        template = .none
        columns.text = .local("Boarder.none")
        none.imageView!.tintColor = .black
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        moveSelector(none)
    }
    
    @objc private func selectSingle() {
        template = .single
        columns.text = .local("Boarder.single")
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        single.imageView!.tintColor = .black
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        moveSelector(single)
    }
    
    @objc private func selectDouble() {
        template = .double
        columns.text = .local("Boarder.double")
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        double.imageView!.tintColor = .black
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        moveSelector(double)
    }
    
    @objc private func selectTriple() {
        template = .triple
        columns.text = .local("Boarder.triple")
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        triple.imageView!.tintColor = .black
        moveSelector(triple)
    }
}
