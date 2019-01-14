import UIKit
import VelvetRoom

class ExportView:UIViewController {
    private weak var board:Board!
    private weak var imageView:UIImageView!
    
    init(_ board:Board) {
        super.init(nibName:nil, bundle:nil)
        self.board = board
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos:.background).async {
            let cgImage = Sharer.export(self.board)
            let image = UIImage(cgImage:cgImage)
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
                UIView.animate(withDuration:0.5) { [weak self] in
                    self?.imageView.alpha = 1
                }
            }
        }
    }
    
    private func makeOutlets() {
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(string:.local("ExportView.title"), attributes:
            [.font:UIFont.systemFont(ofSize:18, weight:.medium), .foregroundColor:UIColor.velvetBlue]))
        mutable.append(NSAttributedString(string:board.name, attributes:
            [.font:UIFont.systemFont(ofSize:18, weight:.medium), .foregroundColor:UIColor.white]))
        
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.numberOfLines = 2
        labelTitle.attributedText = mutable
        view.addSubview(labelTitle)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "delete.pdf"), for:[])
        close.imageView!.contentMode = .center
        close.imageView!.clipsToBounds = true
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(close)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(back)
        
        let share = UIButton()
        share.layer.cornerRadius = 4
        share.backgroundColor = .velvetBlue
        share.translatesAutoresizingMaskIntoConstraints = false
        share.addTarget(self, action:#selector(self.share(_:)), for:.touchUpInside)
        share.setTitle(.local("ExportView.share"), for:[])
        share.setTitleColor(.black, for:.normal)
        share.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        share.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        view.addSubview(share)
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.alpha = 0
        view.addSubview(imageView)
        self.imageView = imageView
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        share.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        share.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-60).isActive = true
        share.widthAnchor.constraint(equalToConstant:88).isActive = true
        share.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        labelTitle.topAnchor.constraint(equalTo:close.topAnchor, constant:12).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant:180).isActive = true
        imageView.heightAnchor.constraint(equalToConstant:180).isActive = true
        
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
    
    @objc private func share(_ button:UIButton) {
        let url = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("\(board.name).png")
        saveTo(url)
        let view = UIActivityViewController(activityItems:[url], applicationActivities:nil)
        if let popover = view.popoverPresentationController {
            popover.sourceView = button
            popover.sourceRect = .zero
            popover.permittedArrowDirections = .any
        }
        presentingViewController!.dismiss(animated:true) {
            Application.view.present(view, animated:true)
        }
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
