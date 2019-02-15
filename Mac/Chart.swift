import AppKit
import VelvetRoom

class Chart:Sheet {
    private weak var masking:CAShapeLayer!
    private var angle = CGFloat()
    
    @discardableResult override init() {
        super.init()
        let title = Label(List.shared.selected.board.name, font:.systemFont(ofSize:20, weight:.bold))
        title.alignment = .center
        title.alphaValue = 0
        addSubview(title)
        
        render()
        
        let done = Button(.local("Chart.done"))
        done.target = self
        done.action = #selector(self.close)
        done.keyEquivalent = "\r"
        addSubview(done)
        
        title.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant:120).isActive = true
        
        done.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-20).isActive = true
        
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
    
    private func render() {
        let chart = NSView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.wantsLayer = true
        chart.layer!.mask = {
            $0.frame = CGRect(x:0, y:0, width:900, height:900)
            $0.lineWidth = 35
            $0.strokeColor = NSColor.black.cgColor
            $0.fillColor = NSColor.clear.cgColor
            masking = $0
            return $0
        } (CAShapeLayer())
        addSubview(chart)

        List.shared.selected.board.chart.enumerated().reduce(into:([CAShapeLayer](), CGFloat(), 0)) {
            let delta = .pi * -2 * CGFloat($1.element.1)
            let radius = delta + $0.1
            $0.0.append(contentsOf: {
                $2.frame = chart.layer!.frame
                $2.path = {
                    $1.move(to:CGPoint(x:450, y:450))
                    $1.addArc(
                        center:CGPoint(x:450, y:450), radius:126, startAngle:$0.1, endAngle:radius, clockwise:true)
                    $1.closeSubpath()
                    return $1
                } ($0, CGMutablePath())
                $2.lineWidth = 2
                $2.strokeColor = Skin.shared.background.withAlphaComponent(0.6).cgColor
                $2.fillColor = $1.offset == List.shared.selected.board.columns.count - 1 ?
                    NSColor.velvetBlue.cgColor :
                    Skin.shared.text.withAlphaComponent(0.2).cgColor
                
                $3.frame = chart.layer!.frame
                $3.path = {
                    $1.move(to:CGPoint(x:450, y:450))
                    $2.move(to:CGPoint(x:450, y:450))
                    $1.addArc(center:CGPoint(x:450, y:450), radius:126, startAngle:$0.1 + (delta / 2),
                              endAngle:$0.1 + (delta / 2), clockwise:true)
                    $2.addArc(center:CGPoint(x:450, y:450), radius:170, startAngle:$0.1 + (delta / 2),
                              endAngle:$0.1 + (delta / 2), clockwise:true)
                    $3.move(to:$1.currentPoint)
                    $3.addLine(to:$2.currentPoint)
                    return $3
                } ($0, CGMutablePath(), CGMutablePath(), CGMutablePath())
                $3.lineWidth = 2
                $3.strokeColor = $2.fillColor
                
                chart.addSubview({
                    $1.attributedStringValue = {
                        $0.append(NSAttributedString(string:$1, attributes:[.font:NSFont.bold(16)]))
                        $0.append(NSAttributedString(string:" \(Int($2 * 100))%", attributes:[.font:NSFont.light(16)]))
                        return $0
                    } (NSMutableAttributedString(), $0.element.0, $0.element.1)
                    return $1
                } ($1, Label()))
                let point = {
                    $1.addArc(center:CGPoint(x:450, y:450), radius:180, startAngle:0, endAngle:$0.1 + (delta / 2),
                              clockwise:true)
                    return $1.currentPoint
                } ($0, CGMutablePath()) as CGPoint
                
                chart.subviews.last!.centerYAnchor.constraint(
                    equalTo:chart.bottomAnchor, constant:-point.y).isActive = true
                
                if point.x > 445 && point.x < 455 {
                    chart.subviews.last!.centerXAnchor.constraint(equalTo:chart.centerXAnchor).isActive = true
                } else if point.x >= 455 {
                    chart.subviews.last!.leftAnchor.constraint(
                        equalTo:chart.leftAnchor, constant:point.x).isActive = true
                } else {
                    chart.subviews.last!.rightAnchor.constraint(
                        equalTo:chart.leftAnchor, constant:point.x).isActive = true
                }
                return [$2, $3]
            } ($0, $1, CAShapeLayer(), CAShapeLayer()) as [CAShapeLayer])
            $0.1 = radius
        }.0.forEach { chart.layer!.addSublayer($0) }
        
        chart.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant:masking.frame.width).isActive = true
        chart.heightAnchor.constraint(equalToConstant:masking.frame.height).isActive = true
    }
    
    @objc private func animate(_ timer:Timer) {
        angle = max(angle - 0.05, .pi * -2)
        masking.path = { $0.addArc(center:CGPoint(x:450, y:450), radius:109, startAngle:0,
                                 endAngle:angle, clockwise:true); return $0 } (CGMutablePath())
        if angle == .pi * -2 {
            timer.invalidate()
            masking.add({
                $0.animations = [{
                    $0.fromValue = masking.path
                    masking.path = { $0.addArc(center:CGPoint(x:450, y:450), radius:450, startAngle:0,
                                               endAngle:.pi * -2, clockwise:true); return $0 } (CGMutablePath())
                    $0.toValue = masking.path
                    return $0
                } (CABasicAnimation(keyPath:"path")), {
                    $0.fromValue = masking.lineWidth
                    masking.lineWidth = 716
                    $0.toValue = masking.lineWidth
                    return $0
                } (CABasicAnimation(keyPath:"lineWidth"))]
                $0.duration = 3
                return $0
            } (CAAnimationGroup()), forKey:nil)
        }
    }
}
