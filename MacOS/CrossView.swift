import AppKit

class CrossView:NSView {
    var knowledge:CGFloat = 0.5
    var empathy:CGFloat = 0.3
    var courage:CGFloat = 0.7
    var diligence:CGFloat = 0.2
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
    }
    
    func update() {
        let side = (min(frame.width, frame.height) / 2) - 50
        circle(side)
        chart(side)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func chart(_ side:CGFloat) {
        let origin = CGMutablePath()
        origin.move(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.closeSubpath()
        
        let destiny = CGMutablePath()
//        destiny.move(to:CGPoint(x:bounds.midX, y:bounds.midY - (side * knowledge)))
//        destiny.addLine(to:CGPoint(x:bounds.midX + (side * empathy), y:bounds.midY))
//        destiny.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY + (side * courage)))
//        destiny.addLine(to:CGPoint(x:bounds.midX - (side * diligence), y:bounds.midY))
//        destiny.closeSubpath()
        
        
        
        let marker = CGMutablePath()
        marker.addArc(center:CGPoint(x:bounds.midX, y:bounds.midY), radius:side * knowledge, startAngle:0, endAngle:0, clockwise:false)
        let knowledgePoint = marker.currentPoint
        destiny.closeSubpath()
        marker.addArc(center:CGPoint(x:bounds.midX, y:bounds.midY), radius:side * empathy, startAngle:0, endAngle:2.0944, clockwise:false)
        let empathyPoint = marker.currentPoint
        destiny.closeSubpath()
        marker.addArc(center:CGPoint(x:bounds.midX, y:bounds.midY), radius:side * courage, startAngle:0, endAngle:4.18879, clockwise:false)
        let couragePoint = marker.currentPoint
        
        destiny.move(to:CGPoint(x:bounds.midX, y:bounds.midY))
        destiny.addLine(to:knowledgePoint)
        destiny.addLine(to:empathyPoint)
        destiny.addLine(to:couragePoint)
        destiny.addLine(to:knowledgePoint)
        destiny.closeSubpath()
        
        let animation = CABasicAnimation(keyPath:"path")
        animation.duration = 1
        animation.fromValue = origin
        animation.toValue = destiny
        
        let layer = CAShapeLayer()
        layer.fillColor = NSColor.velvetBlue.cgColor
        layer.frame = bounds
        layer.add(animation, forKey:String())
        layer.path = destiny
        self.layer!.addSublayer(layer)
    }
    
    private func circle(_ side:CGFloat) {
        let path = CGMutablePath()
        path.addArc(center:CGPoint(x:bounds.midX, y:bounds.midY), radius:side, startAngle:0.0001, endAngle:0, clockwise:false)
        path.move(to:CGPoint(x:bounds.midX - side, y:bounds.midY))
        path.addLine(to:CGPoint(x:bounds.midX + side, y:bounds.midY))
        path.move(to:CGPoint(x:bounds.midX, y:bounds.midY - side))
        path.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY + side))
        path.closeSubpath()
        
        let layer = CAShapeLayer()
        layer.lineDashPattern = [NSNumber(value:1), NSNumber(value:7)]
        layer.strokeColor = NSColor.white.cgColor
        layer.path = path
        layer.lineWidth = 1
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.frame = bounds
        self.layer!.addSublayer(layer)
    }
}
