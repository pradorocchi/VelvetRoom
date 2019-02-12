import UIKit
import VelvetRoom

class Chart:UIViewController {
    private weak var board:Board!
    private weak var chart:UIView!
    
    init(_ board:Board) {
        super.init(nibName:nil, bundle:nil)
        modalTransitionStyle = .crossDissolve
        self.board = board
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
        display(board.chart)
    }
    
    private func makeOutlets() {
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action:#selector(self.done), for:.touchUpInside)
        view.addSubview(back)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .white
        title.font = .bold(20)
        title.text = board.name
        view.addSubview(title)
        
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.isUserInteractionEnabled = false
        view.addSubview(chart)
        self.chart = chart
        
        let done = UIButton()
        done.layer.cornerRadius = 4
        done.backgroundColor = .velvetBlue
        done.addTarget(self, action:#selector(self.done), for:.touchUpInside)
        done.translatesAutoresizingMaskIntoConstraints = false
        done.setTitle(.local("ChartView.done"), for:[])
        done.setTitleColor(.black, for:.normal)
        done.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        done.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        view.addSubview(done)
        
        title.leftAnchor.constraint(equalTo:view.leftAnchor, constant:30).isActive = true
        title.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        chart.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        chart.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant:300).isActive = true
        chart.heightAnchor.constraint(equalToConstant:300).isActive = true
        
        done.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        done.widthAnchor.constraint(equalToConstant:88).isActive = true
        done.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        if #available(iOS 11.0, *) {
            title.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:10).isActive = true
            done.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant:-20).isActive = true
        } else {
            title.topAnchor.constraint(equalTo:view.topAnchor, constant:10).isActive = true
            done.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-20).isActive = true
        }
    }
    
    private func display(_ chart:[(String, Float)]) {
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
        layer.frame = App.shared.view.bounds
        layer.path = path
        layer.fillColor = UIColor.black.cgColor
        self.chart.layer.addSublayer(layer)
    }
    
    private func caption(_ name:String, percent:Float, point:CGPoint) {
        let mutable = NSMutableAttributedString()
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
        }
    }
    
    @objc private func done() { presentingViewController!.dismiss(animated:true) }
}