import UIKit

class Splash:UIView {
    private(set) weak var button:Link!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let cell = CAEmitterCell()
        cell.birthRate = 20
        cell.lifetime = 1000
        cell.velocity = 4
        cell.velocityRange = 4
        cell.scaleRange = 1
        cell.alphaRange = 0.1
        cell.alphaSpeed = -0.005
        cell.contents = #imageLiteral(resourceName: "snow.pdf").cgImage
        cell.emissionRange = .pi
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .sphere
        emitter.emitterCells = [cell]
        emitter.emitterPosition = {
            CGPoint(x:$0, y:$0) } (max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2)
        
        let over = UIView()
        over.translatesAutoresizingMaskIntoConstraints = false
        over.isUserInteractionEnabled = false
        over.layer.addSublayer(emitter)
        addSubview(over)
        
        let image = UIImageView(image:#imageLiteral(resourceName: "splash.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        addSubview(image)
        
        let button = Link(.local("Splash.button"), target:App.shared, selector:#selector(App.shared.newBoard))
        button.isHidden = true
        addSubview(button)
        self.button = button
        
        over.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        over.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        over.widthAnchor.constraint(
            equalToConstant:max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)).isActive = true
        over.heightAnchor.constraint(
            equalToConstant:max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)).isActive = true
        
        image.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo:centerYAnchor, constant:60).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func remove() {
        button.alpha = 0
        UIView.animate(withDuration:0.5, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}
