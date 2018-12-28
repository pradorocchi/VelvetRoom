import UIKit

class NewView:UIViewController, UITextFieldDelegate {
    private weak var field:UITextField!
    private weak var none:UIButton!
    private weak var single:UIButton!
    private weak var double:UIButton!
    private weak var triple:UIButton!
    private weak var selectorX:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .velvetShade
        makeOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        field.becomeFirstResponder()
        selectTriple()
    }
    
    func textFieldShouldReturn(_:UITextField) -> Bool {
        field.resignFirstResponder()
        return true
    }
    
    private func makeOutlets() {
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.isUserInteractionEnabled = false
        labelTitle.textColor = .white
        labelTitle.font = .systemFont(ofSize:18, weight:.bold)
        labelTitle.text = .local("NewView.title")
        view.addSubview(labelTitle)
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        field.tintColor = .white
        field.autocorrectionType = .yes
        field.autocapitalizationType = .sentences
        field.spellCheckingType = .yes
        field.keyboardType = .asciiCapable
        field.keyboardAppearance = .dark
        field.font = .systemFont(ofSize:20, weight:.medium)
        field.textColor = .white
        field.delegate = self
        field.attributedPlaceholder = NSAttributedString(string:.local("NewView.placeholder"),
                                                         attributes:[.foregroundColor:UIColor(white:1, alpha:0.2)])
        view.addSubview(field)
        self.field = field
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor(white:1, alpha:0.2)
        view.addSubview(border)
        
        let cancel = UIButton()
        cancel.addTarget(self, action:#selector(self.cancel), for:.touchUpInside)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle(.local("NewView.cancel"), for:[])
        cancel.setTitleColor(UIColor(white:1, alpha:0.6), for:.normal)
        cancel.setTitleColor(UIColor(white:1, alpha:0.15), for:.highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize:15, weight:.regular)
        view.addSubview(cancel)
        
        let create = UIButton()
        create.layer.cornerRadius = 4
        create.backgroundColor = .velvetBlue
        create.addTarget(self, action:#selector(self.create), for:.touchUpInside)
        create.translatesAutoresizingMaskIntoConstraints = false
        create.setTitle(.local("NewView.create"), for:[])
        create.setTitleColor(.black, for:.normal)
        create.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        create.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        view.addSubview(create)
        
        let selector = UIView()
        selector.isUserInteractionEnabled = false
        selector.backgroundColor = .velvetBlue
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.layer.cornerRadius = 4
        view.addSubview(selector)
        
        let none = UIButton()
        none.addTarget(self, action:#selector(selectNone), for:.touchUpInside)
        none.translatesAutoresizingMaskIntoConstraints = false
        none.setImage(#imageLiteral(resourceName: "none.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        none.imageView!.clipsToBounds = true
        none.imageView!.contentMode = .center
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        view.addSubview(none)
        self.none = none
        
        let single = UIButton()
        single.addTarget(self, action:#selector(selectSingle), for:.touchUpInside)
        single.translatesAutoresizingMaskIntoConstraints = false
        single.setImage(#imageLiteral(resourceName: "single.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        single.imageView!.clipsToBounds = true
        single.imageView!.contentMode = .center
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        view.addSubview(single)
        self.single = single
        
        let double = UIButton()
        double.addTarget(self, action:#selector(selectDouble), for:.touchUpInside)
        double.translatesAutoresizingMaskIntoConstraints = false
        double.setImage(#imageLiteral(resourceName: "double.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        double.imageView!.clipsToBounds = true
        double.imageView!.contentMode = .center
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        view.addSubview(double)
        self.double = double
        
        let triple = UIButton()
        triple.addTarget(self, action:#selector(selectTriple), for:.touchUpInside)
        triple.translatesAutoresizingMaskIntoConstraints = false
        triple.setImage(#imageLiteral(resourceName: "triple.pdf").withRenderingMode(.alwaysTemplate), for:.normal)
        triple.imageView!.clipsToBounds = true
        triple.imageView!.contentMode = .center
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        view.addSubview(triple)
        self.triple = triple
        
        labelTitle.leftAnchor.constraint(equalTo:view.leftAnchor, constant:25).isActive = true
        
        field.topAnchor.constraint(equalTo:labelTitle.bottomAnchor, constant:30).isActive = true
        field.leftAnchor.constraint(equalTo:view.leftAnchor, constant:25).isActive = true
        field.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-25).isActive = true
        field.heightAnchor.constraint(equalToConstant:44).isActive = true
        
        border.leftAnchor.constraint(equalTo:field.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:field.rightAnchor).isActive = true
        border.topAnchor.constraint(equalTo:field.bottomAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        cancel.topAnchor.constraint(equalTo:none.bottomAnchor, constant:50).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:88).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        create.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        create.topAnchor.constraint(equalTo:cancel.topAnchor).isActive = true
        create.widthAnchor.constraint(equalToConstant:88).isActive = true
        create.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        selector.widthAnchor.constraint(equalToConstant:44).isActive = true
        selector.heightAnchor.constraint(equalToConstant:44).isActive = true
        selector.centerYAnchor.constraint(equalTo:none.centerYAnchor).isActive = true
        selectorX = selector.centerXAnchor.constraint(equalTo:view.leftAnchor, constant:-100)
        selectorX.isActive = true
        
        none.topAnchor.constraint(equalTo:border.bottomAnchor, constant:30).isActive = true
        none.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        none.heightAnchor.constraint(equalToConstant:44).isActive = true
        none.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.25).isActive = true
        
        single.topAnchor.constraint(equalTo:none.topAnchor).isActive = true
        single.leftAnchor.constraint(equalTo:none.rightAnchor).isActive = true
        single.heightAnchor.constraint(equalToConstant:44).isActive = true
        single.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.25).isActive = true
        
        double.topAnchor.constraint(equalTo:none.topAnchor).isActive = true
        double.leftAnchor.constraint(equalTo:single.rightAnchor).isActive = true
        double.heightAnchor.constraint(equalToConstant:44).isActive = true
        double.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.25).isActive = true
        
        triple.topAnchor.constraint(equalTo:none.topAnchor).isActive = true
        triple.leftAnchor.constraint(equalTo:double.rightAnchor).isActive = true
        triple.heightAnchor.constraint(equalToConstant:44).isActive = true
        triple.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.25).isActive = true
        
        if #available(iOS 11.0, *) {
            labelTitle.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:20).isActive = true
        } else {
            labelTitle.topAnchor.constraint(equalTo:view.topAnchor, constant:20).isActive = true
        }
    }
    
    private func moveSelector(_ left:CGFloat) {
        selectorX.constant = left
        UIView.animate(withDuration:0.3) { self.view.layoutIfNeeded() }
    }
    
    @objc private func cancel() {
        field.resignFirstResponder()
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func create() {
        field.resignFirstResponder()
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func selectNone() {
        none.imageView!.tintColor = .black
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        moveSelector(none.frame.midX)
    }
    
    @objc private func selectSingle() {
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        single.imageView!.tintColor = .black
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        moveSelector(single.frame.midX)
    }
    
    @objc private func selectDouble() {
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        double.imageView!.tintColor = .black
        triple.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        moveSelector(double.frame.midX)
    }
    
    @objc private func selectTriple() {
        none.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        single.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        double.imageView!.tintColor = UIColor(white:1, alpha:0.2)
        triple.imageView!.tintColor = .black
        moveSelector(triple.frame.midX)
    }
}
