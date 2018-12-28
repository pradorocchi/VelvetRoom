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
    
    required init?(coder:NSCoder) { return nil }
    
    func update(_ chart:[(String, Float)]) {
        let side = (min(frame.width, frame.height) / 2) - 60
        let origin = CGMutablePath()
        let marker = CGMutablePath()
        let destiny = CGMutablePath()
        origin.move(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.addLine(to:CGPoint(x:bounds.midX, y:bounds.midY))
        origin.closeSubpath()
        destiny.move(to:CGPoint(x:bounds.midX, y:bounds.midY))
        
        var angle = CGFloat()
        var first:CGPoint?
        chart.forEach {
            marker.addArc(center:CGPoint(x:bounds.midX, y:bounds.midY), radius:(side * CGFloat($0.1) + 10), startAngle:0,
                          endAngle:angle, clockwise:true)
            destiny.addLine(to:marker.currentPoint)
            if first == nil {
                first = marker.currentPoint
            }
            angle += .pi * -2 / CGFloat(chart.count)
        }
        destiny.addLine(to:first!)
        
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
