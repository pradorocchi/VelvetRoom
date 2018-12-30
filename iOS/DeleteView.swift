import UIKit

class DeleteView:UIViewController {
    private let onConfirm:(() -> Void)
    
    init(_ onConfirm:@escaping(() -> Void)) {
        self.onConfirm = onConfirm
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        makeOutlets()
    }
    
    private func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        blur.alpha = 0.95
        view.addSubview(blur)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action:#selector(close), for:.touchUpInside)
        view.addSubview(back)
        
        let delete = UIButton()
        delete.layer.cornerRadius = 4
        delete.backgroundColor = .velvetBlue
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(self, action:#selector(remove), for:.touchUpInside)
        delete.setTitle(.local("DeleteView.delete"), for:[])
        delete.setTitleColor(.black, for:.normal)
        delete.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        delete.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        view.addSubview(delete)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action:#selector(close), for:.touchUpInside)
        cancel.setTitle(.local("DeleteView.cancel"), for:[])
        cancel.setTitleColor(UIColor(white:1, alpha:0.6), for:.normal)
        cancel.setTitleColor(UIColor(white:1, alpha:0.15), for:.highlighted)
        cancel.titleLabel!.font = .systemFont(ofSize:15, weight:.regular)
        view.addSubview(cancel)
        
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        delete.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        delete.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        delete.widthAnchor.constraint(equalToConstant:88).isActive = true
        delete.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor, constant:20).isActive = true
        cancel.widthAnchor.constraint(equalToConstant:88).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:30).isActive = true
    }
    
    @objc private func close() {
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func remove() {
        onConfirm()
        close()
    }
}
