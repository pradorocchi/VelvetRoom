import AppKit

class Splash:NSView {
    private(set) weak var button:Button!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let over = NSView()
        over.translatesAutoresizingMaskIntoConstraints = false
        over.wantsLayer = true
        addSubview(over)
        
        let cell = CAEmitterCell()
        cell.birthRate = 20
        cell.lifetime = 1000
        cell.velocity = 4
        cell.velocityRange = 4
        cell.scaleRange = 1
        cell.alphaRange = 0.1
        cell.alphaSpeed = -0.005
        cell.contents = NSImage(named:"snow")!.cgImage(forProposedRect:nil, context:nil, hints:nil)
        cell.emissionRange = .pi
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .sphere
        emitter.emitterCells = [cell]
        emitter.emitterPosition = {
            NSPoint(x:$0, y:$0) } (max(NSScreen.main!.frame.width, NSScreen.main!.frame.height) / 2)
        over.layer!.addSublayer(emitter)
        
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
        
        over.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        over.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        over.widthAnchor.constraint(
            equalToConstant:max(NSScreen.main!.frame.width, NSScreen.main!.frame.height)).isActive = true
        over.heightAnchor.constraint(
            equalToConstant:max(NSScreen.main!.frame.width, NSScreen.main!.frame.height)).isActive = true
        
        image.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo:centerYAnchor, constant:80).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
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
