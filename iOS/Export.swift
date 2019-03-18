import UIKit
import VelvetRoom

class Export:Sheet {
    private weak var imageView:UIImageView!
    private weak var buttonShare: Link!
    private let board:Board
    
    @discardableResult init(_ board:Board) {
        self.board = board
        super.init()
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.numberOfLines = 2
        labelTitle.text = board.name
        labelTitle.textColor = Skin.shared.text
        labelTitle.textAlignment = .center
        labelTitle.font = .bold(18)
        addSubview(labelTitle)
        
        let cancel = Link(.local("Export.cancel"), target:self, selector:#selector(close))
        cancel.backgroundColor = .clear
        cancel.setTitleColor(Skin.shared.text.withAlphaComponent(0.6), for:.normal)
        cancel.setTitleColor(Skin.shared.text.withAlphaComponent(0.15), for:.highlighted)
        addSubview(cancel)
        
        let buttonShare = Link(.local("Export.share"), target:self, selector:#selector(share))
        buttonShare.isEnabled = false
        buttonShare.alpha = 0.2
        addSubview(buttonShare)
        self.buttonShare = buttonShare
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.alpha = 0
        addSubview(imageView)
        self.imageView = imageView
        
        buttonShare.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        buttonShare.topAnchor.constraint(equalTo:imageView.bottomAnchor, constant:20).isActive = true
        
        labelTitle.bottomAnchor.constraint(equalTo:imageView.topAnchor, constant:-20).isActive = true
        labelTitle.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant:180).isActive = true
        imageView.heightAnchor.constraint(equalToConstant:180).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:buttonShare.bottomAnchor, constant:20).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func ready() {
        DispatchQueue.global(qos:.background).async {
            let cgImage = Sharer.export(self.board)
            let image = UIImage(cgImage:cgImage)
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    self?.imageView.alpha = 1
                    self?.buttonShare.alpha = 1
                }) { [weak self] _ in
                    self?.buttonShare.isEnabled = true
                }
            }
        }
    }
    
    @objc private func share() {
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("\(board.name).png")
        saveTo(url)
        let view = UIActivityViewController(activityItems:[url], applicationActivities:nil)
        view.popoverPresentationController?.sourceView = self
        view.popoverPresentationController?.sourceRect = .zero
        view.popoverPresentationController?.permittedArrowDirections = .any
        App.shared.rootViewController!.present(view, animated:true)
        close()
    }
    
    private func saveTo(_ url:URL) {
        UIGraphicsBeginImageContext(CGSize(width:800, height:980))
        UIGraphicsGetCurrentContext()!.addRect(CGRect(x:0, y:0, width:800, height:980))
        UIGraphicsGetCurrentContext()!.setFillColor(UIColor.white.cgColor)
        UIGraphicsGetCurrentContext()!.fillPath()
        (board.name as NSString).draw(in:CGRect(x:64, y:100, width:720, height:100), withAttributes:
            [.font:UIFont.systemFont(ofSize:60, weight:.bold), .foregroundColor:UIColor.black])
        imageView.image!.draw(in:CGRect(x:40, y:220, width:720, height:720))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        try! image.pngData()!.write(to:url)
    }
}
