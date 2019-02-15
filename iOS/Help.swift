import UIKit
import VelvetRoom

class Help:Sheet {
    @discardableResult override init() {
        super.init()
        let labelVersion = UILabel()
        labelVersion.translatesAutoresizingMaskIntoConstraints = false
        labelVersion.textColor = Skin.shared.text
        labelVersion.font = .light(12)
        labelVersion.text = .local("Help.version") +
            (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        labelVersion.textAlignment = .center
        labelVersion.numberOfLines = 2
        addSubview(labelVersion)
        
        let close = Link(.local("Help.close"), target:self, selector:#selector(self.close))
        addSubview(close)
        
        let imageView = UIImageView(image:#imageLiteral(resourceName: "splash.pdf"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        let text = Text()
        text.font = .light(Skin.shared.font - 2)
        text.text = .local("Help.content")
        addSubview(text)
        
        imageView.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        imageView.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        labelVersion.bottomAnchor.constraint(equalTo:imageView.bottomAnchor, constant:-35).isActive = true
        labelVersion.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        text.bottomAnchor.constraint(equalTo:close.topAnchor, constant:-80).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        
        close.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            close.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor, constant:-20).isActive = true
        } else {
            close.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-20).isActive = true
        }
    }
    
    required init?(coder:NSCoder) { return nil }
}
