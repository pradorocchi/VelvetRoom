import AppKit

class Splash:NSView {
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
        layer!.addSublayer(emitter)
        self.emitter = emitter
        
        let image = NSImageView()
        image.image = NSImage(named:"splash")
        image.imageScaling = .scaleNone
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        
        image.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        showButton()
        center()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        center()
    }
    
    func showButton() {
        let button = Button(.local("Splash.button"))
        button.target = Toolbar.shared
        button.action = #selector(Toolbar.shared.newBoard)
        addSubview(button)
        
        button.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo:centerYAnchor, constant:80).isActive = true
    }
    
    private func center() {
        emitter.emitterPosition = CGPoint(x:NSApp.windows.first!.frame.width / 2,
                                          y:NSApp.windows.first!.frame.height / 2)
    }
}
