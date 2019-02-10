import AppKit
import VelvetRoom

class Chart:Sheet {
    private weak var chart:CAShapeLayer!
    private weak var names:CAShapeLayer!
    private var chartAngle = CGFloat(0)
    private var namesRadius = CGFloat(0)
    
    @discardableResult init(_ board:Board) {
        super.init()
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.font = .systemFont(ofSize:20, weight:.bold)
        title.textColor = Skin.shared.text
        title.stringValue = board.name
        title.alignment = .center
        title.alphaValue = 0
        addSubview(title)
        
        title.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant:120).isActive = true
        display(board.chart)
        Timer.scheduledTimer(timeInterval:0.01, target:self,
                             selector:#selector(animate(_:)), userInfo:nil, repeats:true)
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.2) {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 3
                context.allowsImplicitAnimation = true
                title.alphaValue = 1
            }, completionHandler:nil)
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func display(_ items:[(String, Float)]) {
        let names = NSView()
        names.translatesAutoresizingMaskIntoConstraints = false
        names.wantsLayer = true
        names.layer!.mask = {
            $0.frame = CGRect(x:0, y:0, width:900, height:900)
            $0.fillColor = NSColor.black.cgColor
            self.names = $0
            return $0
        } (CAShapeLayer())
        addSubview(names)
        
        let chart = NSView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.wantsLayer = true
        chart.layer!.mask = {
            $0.frame = CGRect(x:0, y:0, width:300, height:300)
            $0.lineWidth = 35
            $0.strokeColor = NSColor.black.cgColor
            $0.fillColor = NSColor.clear.cgColor
            self.chart = $0
            return $0
        } (CAShapeLayer())
        addSubview(chart)
        
        var angle = CGFloat()
        items.enumerated().forEach {
            let delta = .pi * -2 * CGFloat($0.element.1)
            let radius = delta + angle
            let layer = CAShapeLayer()
            layer.frame = CGRect(x:0, y:0, width:300, height:300)
            layer.path = {
                $0.move(to:CGPoint(x:150, y:150))
                $0.addArc(center:CGPoint(x:150, y:150), radius:130, startAngle:angle, endAngle:radius, clockwise:true)
                $0.closeSubpath()
                return $0
            } (CGMutablePath())
            layer.lineWidth = 2
            layer.strokeColor = Skin.shared.background.withAlphaComponent(0.6).cgColor
            if $0.offset == items.count - 1 {
                layer.fillColor = NSColor.velvetBlue.cgColor
            } else {
                layer.fillColor = Skin.shared.text.withAlphaComponent(0.2).cgColor
            }
            chart.layer!.addSublayer(layer)
            if $0.element.1 > 0 {
                let line = CAShapeLayer()
                line.frame = CGRect(x:0, y:0, width:900, height:900)
                line.path = {
                    $0.move(to:CGPoint(x:450, y:450))
                    $1.move(to:CGPoint(x:450, y:450))
                    $0.addArc(center:CGPoint(x:450, y:450), radius:127, startAngle:angle + (delta / 2),
                              endAngle:angle + (delta / 2), clockwise:true)
                    $1.addArc(center:CGPoint(x:450, y:450), radius:170, startAngle:angle + (delta / 2),
                              endAngle:angle + (delta / 2), clockwise:true)
                    $2.move(to:$0.currentPoint)
                    $2.addLine(to:$1.currentPoint)
                    return $2
                } (CGMutablePath(), CGMutablePath(), CGMutablePath())
                line.lineWidth = 2
                line.strokeColor = layer.fillColor
                names.layer!.addSublayer(line)
                
                let point:CGPoint = {
                    $0.addArc(center:CGPoint(x:150, y:150), radius:180, startAngle:0, endAngle:angle + (delta / 2),
                              clockwise:true)
                    return $0.currentPoint
                } (CGMutablePath())
                
                let label = NSTextField()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.backgroundColor = .clear
                label.isBezeled = false
                label.isEditable = false
                label.textColor = Skin.shared.text
                label.attributedStringValue = {
                    $0.append(NSAttributedString(string:$1, attributes:[.font:NSFont.bold(16)]))
                    $0.append(NSAttributedString(string:" \(Int($2 * 100))%", attributes:[.font:NSFont.light(16)]))
                    return $0
                } (NSMutableAttributedString(), $0.element.0, $0.element.1)
                names.addSubview(label)
                
                label.centerYAnchor.constraint(equalTo:chart.bottomAnchor, constant:-point.y).isActive = true
                
                if point.x == 150 {
                    label.centerXAnchor.constraint(equalTo:chart.centerXAnchor).isActive = true
                } else if point.x >= 150 {
                    label.leftAnchor.constraint(equalTo:chart.leftAnchor, constant:point.x).isActive = true
                } else {
                    label.rightAnchor.constraint(equalTo:chart.leftAnchor, constant:point.x).isActive = true
                }
            }
            angle = radius
        }
        
        chart.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant:300).isActive = true
        chart.heightAnchor.constraint(equalToConstant:300).isActive = true
        
        names.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        names.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        names.heightAnchor.constraint(equalToConstant:900).isActive = true
        names.widthAnchor.constraint(equalToConstant:900).isActive = true
    }
    
    @objc private func animate(_ timer:Timer) {
        if chartAngle > .pi * -2 {
            chartAngle -= 0.05
            chart.path = { $0.addArc(center:CGPoint(x:150, y:150), radius:109, startAngle:0, endAngle:chartAngle,
                                     clockwise:true); return $0 } (CGMutablePath())
        } else if namesRadius < 450 {
            namesRadius += 3
            names.path = { $0.addArc(center:CGPoint(x:450, y:450), radius:namesRadius, startAngle:0.0001, endAngle:0,
                                     clockwise:false); return $0 } (CGMutablePath())
        } else {
            timer.invalidate()
        }
    }
}
