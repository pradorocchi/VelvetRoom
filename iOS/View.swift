import UIKit

class View:UIViewController {
    private weak var titleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
    }
    
    private func makeOutlets() {
        let newButton = UIButton()
        newButton.addTarget(self, action:#selector(new), for:.touchUpInside)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setImage(#imageLiteral(resourceName: "new.pdf"), for:.normal)
        newButton.imageView!.clipsToBounds = true
        newButton.imageView!.contentMode = .center
        view.addSubview(newButton)
        
        let progressButton = ProgressView()
        view.addSubview(progressButton)
        
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        deleteButton.imageView!.clipsToBounds = true
        deleteButton.imageView!.contentMode = .center
        deleteButton.isEnabled = false
        view.addSubview(deleteButton)
        
        let listButton = UIButton()
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setImage(#imageLiteral(resourceName: "list.pdf"), for:.normal)
        listButton.imageView!.clipsToBounds = true
        listButton.imageView!.contentMode = .center
        listButton.isEnabled = false
        view.addSubview(listButton)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = .light(15)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        newButton.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        newButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        newButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        progressButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        progressButton.rightAnchor.constraint(equalTo:newButton.leftAnchor).isActive = true
        progressButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        progressButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo:progressButton.leftAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        deleteButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        listButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        listButton.rightAnchor.constraint(equalTo:deleteButton.leftAnchor).isActive = true
        listButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        listButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:newButton.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-18).isActive = true
        
        if #available(iOS 11.0, *) {
            newButton.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            newButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    @objc private func new() {
        present(NewView(), animated:true)
    }
}
