import UIKit
import VelvetRoom

class Chart:Sheet {
    @discardableResult override init() {
        super.init()
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Skin.shared.text
        title.font = .bold(20)
        title.text = List.shared.selected.board.name
        addSubview(title)
        
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.isUserInteractionEnabled = false
        addSubview(chart)
        
        let done = Link(.local("Chart.done"), target:self, selector:#selector(close))
        addSubview(done)
        
        title.leftAnchor.constraint(equalTo:leftAnchor, constant:30).isActive = true
        title.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        chart.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant:300).isActive = true
        chart.heightAnchor.constraint(equalToConstant:300).isActive = true
        
        done.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            title.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor, constant:10).isActive = true
            done.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor, constant:-20).isActive = true
        } else {
            title.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
            done.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-20).isActive = true
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    private func display() {/*
        var angle = CGFloat()
        chart.enumerated().forEach {
            let delta = .pi * 2 * CGFloat($0.element.1)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:CGPoint(x:150, y:150))
            if $0.element.1 > 0 {
                let name = CGMutablePath()
                name.addArc(center:CGPoint(x:150, y:150),
                            radius:80, startAngle:0, endAngle:angle + (delta / 2), clockwise:false)
                caption($0.element.0, percent:$0.element.1, point:name.currentPoint)
            }
            path.addArc(center:CGPoint(x:150, y:150), radius:70, startAngle:angle, endAngle:radius, clockwise:false)
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = CGRect(x:0, y:0, width:300, height:300)
            layer.path = path
            layer.lineWidth = 4
            layer.lineJoin = .round
            layer.lineCap = .round
            layer.strokeColor = UIColor.black.cgColor
            if $0.offset == chart.count - 1 {
                layer.fillColor = UIColor.velvetBlue.cgColor
            } else {
                layer.fillColor = UIColor.velvetBlue.withAlphaComponent(0.3).cgColor
            }
            self.chart.layer.addSublayer(layer)
            angle = radius
        }
        let path = CGMutablePath()
        path.addArc(center:CGPoint(x:150, y:150), radius:40, startAngle:0.0001, endAngle:0, clockwise:false)
        let layer = CAShapeLayer()
//        layer.frame = App.shared.view.bounds
        layer.path = path
        layer.fillColor = UIColor.black.cgColor
        self.chart.layer.addSublayer(layer)*/
    }
    
    private func caption(_ name:String, percent:Float, point:CGPoint) {
        /*let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(
            string:name, attributes:[.font:UIFont.systemFont(ofSize:12, weight:.medium)]))
        mutable.append(NSAttributedString(
            string:" - \(Int(percent * 100))", attributes:[.font:UIFont.systemFont(ofSize:10, weight:.ultraLight)]))
        mutable.append(NSAttributedString(
            string:"%", attributes:[.font:UIFont.systemFont(ofSize:8, weight:.ultraLight)]))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.attributedText = mutable
        label.numberOfLines = 2
        chart.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:chart.topAnchor, constant:point.y).isActive = true
        
        if point.x == 150 {
            label.centerXAnchor.constraint(equalTo:chart.centerXAnchor).isActive = true
        } else if point.x > 150 {
            label.leftAnchor.constraint(equalTo:chart.leftAnchor, constant:point.x).isActive = true
        } else {
            label.rightAnchor.constraint(equalTo:chart.leftAnchor, constant:point.x).isActive = true
        }*/
    }
}
