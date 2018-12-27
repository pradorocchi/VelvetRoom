import AppKit

class CrossView:NSView {
    var knowledge:CGFloat = 0.2
    var empathy:CGFloat = 0.5
    var courage:CGFloat = 0.4
    var diligence:CGFloat = 0.3
    private weak var chart:CAShapeLayer?
    private weak var circle:CAShapeLayer?
    private weak var cross:CAShapeLayer?
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
//        backgroundColor = .clear
    }
    
    func update() {
        let side = min(frame.width, frame.height) / 2
        circle(side)
        chart(side)
        cross(side)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func chart(_ side:CGFloat) {
        self.chart?.removeFromSuperlayer()
        let origin = NSBezierPath()
        origin.move(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.line(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.close()
        
        let destiny = CGMutablePath()
        destiny.move(to:CGPoint(x:bounds.midX, y:bounds.midY - (side * knowledge)))
        destiny.addLine(to:CGPoint(x:bounds.midX + (side * empathy), y:bounds.midY))
        destiny.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY + (side * courage)))
        destiny.addLine(to:CGPoint(x:bounds.midX - (side * diligence), y:bounds.midY))
        destiny.closeSubpath()
        
        let animation = CABasicAnimation(keyPath:"path")
        animation.duration = 1
        animation.fromValue = origin.flattened
        animation.toValue = destiny
        
        let layer = CAShapeLayer()
        layer.fillColor = NSColor.velvetBlue.cgColor
        layer.frame = bounds
        layer.add(animation, forKey:String())
        layer.path = destiny
        self.chart = layer
        self.layer!.addSublayer(layer)
    }
    
    private func circle(_ side:CGFloat) {
        self.circle?.removeFromSuperlayer()
        let path = CGMutablePath()
        path.addArc(center:CGPoint(x:bounds.midX, y:bounds.midY), radius:side, startAngle:0.0001, endAngle:0, clockwise:true)
        path.move(to:CGPoint(x:bounds.midX - side, y:bounds.midY))
        path.addLine(to:CGPoint(x:bounds.midX + side, y:bounds.midY))
        path.move(to:CGPoint(x:bounds.midX, y:bounds.midY - side))
        path.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY + side))
        path.closeSubpath()
        
        let layer = CAShapeLayer()
        layer.lineDashPattern = [NSNumber(value:1), NSNumber(value:6)]
        layer.strokeColor = NSColor.velvetBlue.cgColor
        layer.path = path
        layer.lineWidth = 1
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.frame = bounds
        self.circle = layer
        self.layer!.addSublayer(layer)
    }
    
    private func cross(_ side:CGFloat) {
        self.cross?.removeFromSuperlayer()
        let origin = CGMutablePath()
        origin.move(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.closeSubpath()
        
        let destiny = CGMutablePath()
        destiny.move(to:CGPoint(x:bounds.midX - (side * diligence), y:bounds.midY))
        destiny.addLine(to:CGPoint(x:bounds.midX + (side * empathy ), y:bounds.midY))
        destiny.move(to:CGPoint(x:bounds.midX, y:bounds.midY - (side * knowledge)))
        destiny.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY + (side * courage)))
        
        let animation = CABasicAnimation(keyPath:"path")
        animation.duration = 1
        animation.fromValue = origin
        animation.toValue = destiny
        
        let layer = CAShapeLayer()
        layer.strokeColor = NSColor.velvetBlue.cgColor
        layer.lineWidth = 1
        layer.frame = bounds
        layer.add(animation, forKey:String())
        layer.path = destiny
        self.cross = layer
        self.layer!.addSublayer(layer)
    }
}
