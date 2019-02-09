import AppKit
import VelvetRoom

class Chart:Sheet {
    @discardableResult init(_ board:Board) {
        super.init()
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:16, weight:.bold)
        title.textColor = Skin.shared.text
        title.stringValue = board.name
        title.alignment = .center
        addSubview(title)
        
        title.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo:topAnchor, constant:40).isActive = true
        display(board.chart)
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func display(_ items:[(String, Float)]) {
        let chart = NSView()
        chart.wantsLayer = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chart)
        
        let maskPath = CGMutablePath()
        maskPath.addArc(center:CGPoint(x:150, y:150), radius:115, startAngle:0.001, endAngle:0, clockwise:false)
        let mask = CAShapeLayer()
        mask.frame = CGRect(x:0, y:0, width:300, height:300)
        mask.path = maskPath
        mask.lineWidth = 30
        mask.strokeColor = NSColor.black.cgColor
        mask.fillColor = NSColor.clear.cgColor
        chart.layer!.mask = mask
        
        var angle = CGFloat()
        items.enumerated().forEach {
            let delta = .pi * -2 * CGFloat($0.element.1)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:CGPoint(x:150, y:150))
            path.addArc(center:CGPoint(x:150, y:150), radius:130, startAngle:angle, endAngle:radius, clockwise:true)
            if $0.element.1 > 0 {
                let name = CGMutablePath()
                name.addArc(center:CGPoint(x:26, y:26), radius:140, startAngle:0, endAngle:angle + (delta / 2), clockwise:true)
                caption($0.element.0, percent:$0.element.1, point:name.currentPoint)
            }
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = CGRect(x:0, y:0, width:300, height:300)
            layer.path = path
            layer.lineWidth = 1
            layer.strokeColor = NSColor(white:0, alpha:0.4).cgColor
            if $0.offset == items.count - 1 {
                layer.fillColor = NSColor.velvetBlue.cgColor
            } else {
                layer.fillColor = NSColor.textColor.withAlphaComponent(0.2).cgColor
            }
            chart.layer!.addSublayer(layer)
            angle = radius
        }
        chart.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant:300).isActive = true
        chart.heightAnchor.constraint(equalToConstant:300).isActive = true
    }
    
    private func caption(_ name:String, percent:Float, point:CGPoint) {
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(
            string:name, attributes:[.font:NSFont.systemFont(ofSize:14, weight:.medium)]))
        mutable.append(NSAttributedString(
            string:" - \(Int(percent * 100))", attributes:[.font:NSFont.systemFont(ofSize:12, weight:.ultraLight)]))
        mutable.append(NSAttributedString(
            string:"%", attributes:[.font:NSFont.systemFont(ofSize:8, weight:.ultraLight)]))
        
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
