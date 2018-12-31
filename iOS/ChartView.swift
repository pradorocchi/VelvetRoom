import UIKit
import VelvetRoom

class ChartView:UIViewController {
    private weak var board:Board!
    
    init(_ board:Board) {
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        self.board = board
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        makeOutlets()
        display(board.chart)
    }
    
    private func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        blur.alpha = 0.94
        view.addSubview(blur)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action:#selector(self.done), for:.touchUpInside)
        view.addSubview(back)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.isUserInteractionEnabled = false
        title.textColor = .white
        title.font = .bold(20)
        title.text = board.name
        view.addSubview(title)
        
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
        
        title.leftAnchor.constraint(equalTo:view.leftAnchor, constant:32).isActive = true
        title.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        done.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-50).isActive = true
        done.widthAnchor.constraint(equalToConstant:88).isActive = true
        done.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        if #available(iOS 11.0, *) {
            title.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:10).isActive = true
        } else {
            title.topAnchor.constraint(equalTo:view.topAnchor, constant:10).isActive = true
        }
    }
    
    private func display(_ chart:[(String, Float)]) {
        var angle = CGFloat()
        let center = CGPoint(x:Application.view.view.bounds.width / 2, y:Application.view.view.bounds.height / 2)
        chart.enumerated().forEach {
            let delta = .pi * 2 * CGFloat($0.element.1)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:center)
            if $0.element.1 > 0 {
                let name = CGMutablePath()
                name.addArc(center:center, radius:90, startAngle:0, endAngle:angle + (delta / 2), clockwise:false)
                caption($0.element.0, percent:$0.element.1, point:name.currentPoint)
            }
            path.addArc(center:center, radius:70, startAngle:angle, endAngle:radius, clockwise:false)
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = Application.view.view.bounds
            layer.path = path
            layer.lineWidth = 5
            layer.strokeColor = UIColor.black.cgColor
            if $0.offset == chart.count - 1 {
                layer.fillColor = UIColor.velvetBlue.withAlphaComponent(0.3).cgColor
            } else {
                layer.fillColor = UIColor.velvetBlue.cgColor
            }
            view.layer.addSublayer(layer)
            angle = radius
        }
    }
    
    private func caption(_ name:String, percent:Float, point:CGPoint) {
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(
            string:name, attributes:[.font:UIFont.systemFont(ofSize:14, weight:.medium)]))
        mutable.append(NSAttributedString(
            string:"\n\(Int(percent * 100))%", attributes:[.font:UIFont.systemFont(ofSize:12, weight:.ultraLight)]))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        label.textColor = .white
        label.attributedText = mutable
        label.numberOfLines = 2
        view.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:view.topAnchor, constant:point.y).isActive = true
        
        if point.x == Application.view.view.bounds.midX {
            label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        } else if point.x >= Application.view.view.bounds.midX {
            label.leftAnchor.constraint(equalTo:view.leftAnchor, constant:point.x).isActive = true
        } else {
            label.rightAnchor.constraint(equalTo:view.leftAnchor, constant:point.x).isActive = true
        }
    }
    
    @objc private func done() { presentingViewController!.dismiss(animated:true) }
}
