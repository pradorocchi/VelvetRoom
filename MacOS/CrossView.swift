import AppKit

class CrossView:NSView {
    init(_ chart:[(String, Float)]) {
        super.init(frame:Application.shared.view.frame)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        display(chart)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func display(_ chart:[(String, Float)]) {
        var angle = CGFloat()
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        chart.enumerated().forEach {
            let delta = .pi * -2 * CGFloat($0.element.1)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:center)
            if $0.element.1 > 0 {
                let name = CGMutablePath()
                name.addArc(center:center, radius:130, startAngle:0, endAngle:angle + (delta / 2), clockwise:true)
                caption($0.element.0, percent:$0.element.1, point:name.currentPoint)
            }
            path.addArc(center:center, radius:100, startAngle:angle, endAngle:radius, clockwise:true)
            
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = bounds
            layer.path = path
            layer.lineWidth = 5
            layer.strokeColor = NSColor.black.cgColor
            if $0.offset == chart.count - 1 {
                layer.fillColor = NSColor.velvetBlue.cgColor
            } else {
                layer.fillColor = NSColor.velvetBlue.withAlphaComponent(0.3).cgColor
            }
            self.layer!.addSublayer(layer)
            angle = radius
        }
        
        let path = CGMutablePath()
        path.addArc(center:center, radius:60, startAngle:0.001, endAngle:0, clockwise:false)
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path
        layer.fillColor = NSColor.black.cgColor
        self.layer!.addSublayer(layer)
    }
    
    private func caption(_ name:String, percent:Float, point:CGPoint) {
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(
            string:name, attributes:[.font:NSFont.systemFont(ofSize:16, weight:.medium)]))
        mutable.append(NSAttributedString(
            string:"\n\(Int(percent * 100))%", attributes:[.font:NSFont.systemFont(ofSize:14, weight:.ultraLight)]))
        
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.isBezeled = false
        label.isEditable = false
        label.textColor = .white
        label.attributedStringValue = mutable
        addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:bottomAnchor, constant:-point.y).isActive = true
        
        if point.x == bounds.midX {
            label.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        } else if point.x >= bounds.midX {
            label.leftAnchor.constraint(equalTo:leftAnchor, constant:point.x).isActive = true
        } else {
            label.rightAnchor.constraint(equalTo:leftAnchor, constant:point.x).isActive = true
        }
    }
}
