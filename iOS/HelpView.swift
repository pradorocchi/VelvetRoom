import UIKit

class HelpView:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .velvetShade
        makeOutlets()
    }
    
    private func makeOutlets() {
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.isUserInteractionEnabled = false
        labelTitle.textColor = .velvetBlue
        labelTitle.font = .systemFont(ofSize:18, weight:.bold)
        labelTitle.text = .local("HelpView.title")
        view.addSubview(labelTitle)
        
        let labelVersion = UILabel()
        labelVersion.translatesAutoresizingMaskIntoConstraints = false
        labelVersion.isUserInteractionEnabled = false
        labelVersion.textColor = .white
        labelVersion.font = .systemFont(ofSize:12, weight:.ultraLight)
        labelVersion.text = .local("HelpView.version") +
            (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        labelVersion.textAlignment = .center
        view.addSubview(labelVersion)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "delete.pdf"), for:[])
        close.imageView!.contentMode = .center
        close.imageView!.clipsToBounds = true
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(close)
        
        let imageView = UIImageView(image:#imageLiteral(resourceName: "splash.pdf"))
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        let text = TextView()
        text.font = .light(14)
        text.text = .local("HelpView.content")
        view.addSubview(text)
        
        labelTitle.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo:labelTitle.bottomAnchor, constant:100).isActive = true
        imageView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant:100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        labelVersion.topAnchor.constraint(equalTo:imageView.bottomAnchor).isActive = true
        labelVersion.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        
        text.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-40).isActive = true
        text.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        text.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        
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
