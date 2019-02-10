import AppKit

class Splash:NSView {
    private(set) weak var button:Button!
    private weak var emitter:CAEmitterLayer!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 500
        cell.velocity = 6
        cell.velocityRange = 6
        cell.scaleRange = 1
        cell.alphaRange = 0.1
        cell.alphaSpeed = -0.005
        cell.contents = NSImage(named:"snow")!.cgImage(forProposedRect:nil, context:nil, hints:nil)
        cell.emissionRange = .pi
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .sphere
        emitter.emitterCells = [cell]
        emitter.emitterPosition = CGPoint(x:Window.shared.frame.width / 2, y:Window.shared.frame.height / 2)
        layer!.addSublayer(emitter)
        self.emitter = emitter
        
        let image = NSImageView()
        image.image = NSImage(named:"splash")
        image.imageScaling = .scaleNone
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        
        let button = Button(.local("Splash.button"))
        button.target = Window.shared
        button.action = #selector(Window.shared.newBoard)
        button.isHidden = true
        addSubview(button)
        self.button = button
        
        image.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo:centerYAnchor, constant:80).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        emitter.emitterPosition = CGPoint(x:Window.shared.frame.width / 2, y:Window.shared.frame.height / 2)
    }
    
    func remove() {
        button.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.5
            context.allowsImplicitAnimation = true
            alphaValue = 0
        }) { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
