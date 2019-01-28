import UIKit
import NotificationCenter

@objc(WidgetView) class WidgetView:UIViewController, NCWidgetProviding {
    private weak var effect:UIVisualEffectView!
    private weak var chart:UIView?
    private weak var name:UILabel?
    private weak var nextButton:UIButton?
    private weak var previousButton:UIButton?
    private var items = [Widget]()
    private var index = Int()
    private var compact = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let effect:UIVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetSecondary())
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.notificationCenter())
        }
        effect.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effect)
        self.effect = effect
        
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(open), for:.touchUpInside)
        button.addTarget(self, action:#selector(highlight), for:.touchDown)
        button.addTarget(self, action:#selector(unhighlight), for:[.touchUpOutside, .touchUpInside, .touchCancel])
        effect.contentView.addSubview(button)
        
        effect.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        effect.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        effect.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        effect.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        button.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        button.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        button.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    }
    
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        items = Widget.items
        if !items.isEmpty {
            index = Widget.index
            if index >= items.count {
                index = 0
                Widget.index = index
            }
            render()
            display()
            completionHandler(.newData)
        } else {
            empty()
            completionHandler(.noData)
        }
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode:NCWidgetDisplayMode, withMaximumSize maxSize:CGSize) {
        preferredContentSize = CGSize(width:maxSize.width, height:min(maxSize.height, 280))
        compact = activeDisplayMode == .compact
        name?.removeFromSuperview()
        nextButton?.removeFromSuperview()
        previousButton?.removeFromSuperview()
        chart?.removeFromSuperview()
        if !items.isEmpty {
            render()
            display()
        }
    }
    
    private func empty() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize:16, weight:.ultraLight)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "No boards created"
        effect.contentView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
    }
    
    private func render() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .black
        name.textAlignment = .center
        name.alpha = 0
        effect.contentView.addSubview(name)
        self.name = name
        
        let nextButton = UIButton()
        nextButton.addTarget(self, action:#selector(showNext), for:.touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(#imageLiteral(resourceName: "next.pdf"), for:.normal)
        nextButton.imageView!.clipsToBounds = true
        nextButton.imageView!.contentMode = .center
        nextButton.alpha = 0
        view.addSubview(nextButton)
        self.nextButton = nextButton
        
        let previousButton = UIButton()
        previousButton.addTarget(self, action:#selector(showPrevious), for:.touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setImage(#imageLiteral(resourceName: "previous.pdf"), for:.normal)
        previousButton.imageView!.clipsToBounds = true
        previousButton.imageView!.contentMode = .center
        previousButton.alpha = 0
        view.addSubview(previousButton)
        self.previousButton = previousButton
        
        nextButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        previousButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        if compact {
            name.font = .systemFont(ofSize:14, weight:.regular)
            name.leftAnchor.constraint(equalTo:previousButton.leftAnchor).isActive = true
            name.rightAnchor.constraint(equalTo:nextButton.rightAnchor).isActive = true
            name.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
            
            nextButton.leftAnchor.constraint(equalTo:previousButton.rightAnchor, constant:100).isActive = true
            nextButton.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
            
            previousButton.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
            previousButton.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        } else {
            name.font = .systemFont(ofSize:18, weight:.medium)
            name.centerYAnchor.constraint(equalTo:nextButton.centerYAnchor).isActive = true
            name.leftAnchor.constraint(equalTo:previousButton.rightAnchor).isActive = true
            name.rightAnchor.constraint(equalTo:nextButton.leftAnchor).isActive = true
            
            nextButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            nextButton.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
            
            previousButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
            previousButton.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        }
        
        UIView.animate(withDuration:1) { [weak self] in
            self?.name?.alpha = 1
            self?.nextButton?.alpha = 1
            self?.previousButton?.alpha = 1
        }
    }
    
    private func display() {
        name?.text = items[index].name
        let chart = newChart()
        UIView.animate(withDuration:1, animations: { [weak self] in
            chart.alpha = 1
            self?.chart?.alpha = 0
        }) { [weak self] _ in
            self?.chart?.removeFromSuperview()
            self?.chart = chart
        }
    }
    
    private func newChart() -> UIView {
        let center:CGPoint
        let radius:CGFloat
        let extra:CGFloat
        
        if compact {
            center = CGPoint(x:view.bounds.width - 55, y:47)
            radius = 20
            extra = 0
        } else {
            center = CGPoint(x:view.bounds.midX, y:160)
            radius = 50
            extra = 20
        }
        
        let chart = UIView()
        chart.alpha = 0
        chart.isUserInteractionEnabled = false
        chart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chart)
        
        var angle = CGFloat()
        let maskPath = CGMutablePath()
        maskPath.addArc(center:center, radius:radius + ((16 + extra) / 2),
                        startAngle:0.001, endAngle:0, clockwise:false)
        let mask = CAShapeLayer()
        mask.frame = view.bounds
        mask.path = maskPath
        mask.lineWidth = 18 + extra
        mask.strokeColor = UIColor.black.cgColor
        mask.fillColor = UIColor.clear.cgColor
        chart.layer.mask = mask
        
        items[index].columns.enumerated().forEach {
            let delta = .pi * 2 * CGFloat($0.element)
            let current = delta + angle
            let path = CGMutablePath()
            path.move(to:center)
            path.addArc(center:center, radius:radius + 16 + extra, startAngle:angle, endAngle:current, clockwise:false)
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = view.bounds
            layer.path = path
            layer.lineWidth = 2
            layer.strokeColor = UIColor.black.cgColor
            if $0.offset == items[index].columns.count - 1 {
                layer.fillColor = UIColor.velvetBlue.cgColor
            } else {
                layer.fillColor = UIColor.velvetBlue.withAlphaComponent(0.2).cgColor
            }
            chart.layer.addSublayer(layer)
            angle = current
        }
        
        let path = CGMutablePath()
        path.addArc(center:center, radius:radius, startAngle:0.001, endAngle:0, clockwise:false)
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path
        layer.lineWidth = 2
        layer.strokeColor = UIColor.black.cgColor
        chart.layer.addSublayer(layer)
        
        chart.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        chart.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        chart.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        return chart
    }
    
    @objc private func highlight() { view.alpha = 0.15 }
    @objc private func unhighlight() { view.alpha = 1 }
    
    @objc private func open() {
        extensionContext?.open(URL(string:"velvetroom:")!, completionHandler:nil)
    }
    
    @objc private func showNext() {
        index = index < items.count - 1 ? index + 1 : 0
        Widget.index = index
        display()
    }
    
    @objc private func showPrevious() {
        index = index > 0 ? index - 1 : items.count - 1
        Widget.index = index
        display()
    }
}
