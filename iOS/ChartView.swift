import UIKit
import VelvetRoom

class ChartView:UIViewController {
    private weak var board:Board!
    
    init(_ board:Board) {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
    }
    
    private func makeOutlets() {
        let done = UIButton()
        done.layer.cornerRadius = 4
        done.backgroundColor = .velvetBlue
        done.addTarget(self, action:#selector(self.done), for:.touchUpInside)
        done.translatesAutoresizingMaskIntoConstraints = false
        done.setTitle(.local("ChartView.done"), for:[])
        done.setTitleColor(.black, for:.normal)
        done.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        done.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        view.addSubview(done)
        
        done.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-50).isActive = true
        done.widthAnchor.constraint(equalToConstant:88).isActive = true
        done.heightAnchor.constraint(equalToConstant:30).isActive = true
    }
    
    @objc private func done() { presentingViewController!.dismiss(animated:true) }
}
