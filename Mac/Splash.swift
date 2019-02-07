import AppKit

class Splash:NSView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 500
        cell.velocity = 6
        cell.velocityRange = 6
        cell.scaleRange = 1
        cell.alphaRange = 1
        cell.alphaSpeed = -0.005
        cell.contents = NSImage(named:"snow")!.cgImage(forProposedRect:nil, context:nil, hints:nil)
        cell.emissionRange = .pi
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x:NSApp.windows.first!.frame.width / 2,
                                          y:NSApp.windows.first!.frame.height / 2)
        emitter.emitterShape = .point
        emitter.emitterSize = CGSize(width:1, height:1)
        emitter.emitterCells = [cell]
        layer!.addSublayer(emitter)
        
        let image = NSImageView()
        image.image = NSImage(named:"splash")
        image.imageScaling = .scaleNone
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
}
