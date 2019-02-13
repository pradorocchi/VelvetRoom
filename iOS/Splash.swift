import UIKit

class Splash:UIView {
    private weak var button:UIButton!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        let emptyButton = UIButton()
        emptyButton.layer.cornerRadius = 4
        emptyButton.backgroundColor = .velvetBlue
        emptyButton.translatesAutoresizingMaskIntoConstraints = false
//        emptyButton.addTarget(self, action:#selector(new), for:.touchUpInside)
        emptyButton.setTitle(.local("View.emptyButton"), for:[])
        emptyButton.setTitleColor(.black, for:.normal)
        emptyButton.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        emptyButton.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        emptyButton.isHidden = true
//        view.addSubview(emptyButton)
//        self.emptyButton = emptyButton
    }
    
    required init?(coder:NSCoder) { return nil }
}
