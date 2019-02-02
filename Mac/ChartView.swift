import AppKit
import VelvetRoom

class ChartView:SheetView {
    init(_ board:Board) {
        super.init()
        let done = NSButton()
        done.target = self
        done.action = #selector(self.end)
        done.image = NSImage(named:"close")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.keyEquivalent = "\u{1b}"
        done.title = String()
        contentView!.addSubview(done)
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:16, weight:.bold)
        title.textColor = .velvetBlue
        title.stringValue = board.name
        contentView!.addSubview(title)
        
        let end = NSButton()
        end.title = String()
        end.target = self
        end.action = #selector(self.end)
        end.isBordered = false
        end.keyEquivalent = "\r"
        contentView!.addSubview(end)
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:24).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.centerYAnchor.constraint(equalTo:done.centerYAnchor).isActive = true
        
        display(board.chart)
    }
    
    private func display(_ chart:[(String, Float)]) {
        var angle = CGFloat()
        let center = CGPoint(x:contentView!.bounds.midX, y:contentView!.bounds.midY)
        chart.enumerated().forEach {
            let delta = .pi * -2 * CGFloat($0.element.1)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:center)
            if $0.element.1 > 0 {
                let name = CGMutablePath()
                name.addArc(center:center, radius:120, startAngle:0, endAngle:angle + (delta / 2), clockwise:true)
                caption($0.element.0, percent:$0.element.1, point:name.currentPoint)
            }
            path.addArc(center:center, radius:100, startAngle:angle, endAngle:radius, clockwise:true)
            
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = contentView!.bounds
            layer.path = path
            layer.lineWidth = 5
            layer.strokeColor = NSColor.black.cgColor
            if $0.offset == chart.count - 1 {
                layer.fillColor = NSColor.velvetBlue.cgColor
            } else {
                layer.fillColor = NSColor.velvetBlue.withAlphaComponent(0.3).cgColor
            }
            contentView!.layer!.addSublayer(layer)
            angle = radius
        }
        
        let path = CGMutablePath()
        path.addArc(center:center, radius:60, startAngle:0.001, endAngle:0, clockwise:false)
        let layer = CAShapeLayer()
        layer.frame = contentView!.bounds
        layer.path = path
        layer.fillColor = NSColor.black.cgColor
        contentView!.layer!.addSublayer(layer)
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
        contentView!.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-point.y).isActive = true
        
        if point.x == contentView!.bounds.midX {
            label.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        } else if point.x >= contentView!.bounds.midX {
            label.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:point.x).isActive = true
        } else {
            label.rightAnchor.constraint(equalTo:contentView!.leftAnchor, constant:point.x).isActive = true
        }
    }
}
