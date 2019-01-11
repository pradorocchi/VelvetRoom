import UIKit

class CameraView:UIViewController {
    init() {
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .velvetShade
        makeOutlets()
    }
    
    private func makeOutlets() {
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.isUserInteractionEnabled = false
        labelTitle.textColor = .white
        labelTitle.font = .systemFont(ofSize:14, weight:.regular)
        labelTitle.text = .local("CameraView.title")
        view.addSubview(labelTitle)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "delete.pdf"), for:[])
        close.imageView!.contentMode = .center
        close.imageView!.clipsToBounds = true
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(close)
        
        labelTitle.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        close.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        close.widthAnchor.constraint(equalToConstant:50).isActive = true
        close.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        if #available(iOS 11.0, *) {
            close.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            close.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    @objc private func close() {
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
}
