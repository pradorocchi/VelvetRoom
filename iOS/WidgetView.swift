import UIKit
import NotificationCenter

@objc(WidgetView) class WidgetView:UIViewController, NCWidgetProviding {
    private weak var effect:UIVisualEffectView!
    private weak var name:UILabel!
    private weak var display:UIView?
    private var items = [(String,[WidgetItem])]()
    private var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Widget.group = "group.VelvetRoom"
        let effect:UIVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetPrimary())
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
        items = Widget.items.map { ($0, $1) }.sorted {
            $0.0.compare($1.0, options:.caseInsensitive) == .orderedAscending }
        if items.isEmpty {
            empty()
            completionHandler(.noData)
        } else {
            index = Widget.index
            if index >= items.count {
                index = 0
                Widget.index = index
            }
            render()
            update()
            completionHandler(.newData)
        }
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode:NCWidgetDisplayMode, withMaximumSize maxSize:CGSize) {
        preferredContentSize = maxSize
        if !items.isEmpty {
            update()
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
        preferredContentSize.height = 50
    }
    
    private func render() {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .black
        name.font = .systemFont(ofSize:20, weight:.bold)
        effect.contentView.addSubview(name)
        self.name = name
        
        let nextButton = UIButton()
        nextButton.addTarget(self, action:#selector(showNext), for:.touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(#imageLiteral(resourceName: "next.pdf"), for:.normal)
        nextButton.imageView!.clipsToBounds = true
        nextButton.imageView!.contentMode = .center
        view.addSubview(nextButton)
        
        let previousButton = UIButton()
        previousButton.addTarget(self, action:#selector(showPrevious), for:.touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setImage(#imageLiteral(resourceName: "previous.pdf"), for:.normal)
        previousButton.imageView!.clipsToBounds = true
        previousButton.imageView!.contentMode = .center
        view.addSubview(previousButton)
        
        name.topAnchor.constraint(equalTo:view.topAnchor, constant:33).isActive = true
        name.leftAnchor.constraint(equalTo:view.leftAnchor, constant:70).isActive = true
        name.rightAnchor.constraint(equalTo:previousButton.leftAnchor).isActive = true
        
        nextButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        nextButton.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo:name.centerYAnchor).isActive = true
        
        previousButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        previousButton.rightAnchor.constraint(equalTo:nextButton.leftAnchor).isActive = true
        previousButton.centerYAnchor.constraint(equalTo:name.centerYAnchor).isActive = true
    }
    
    private func update() {
        name.text = items[index].0
        let display = newDisplay()
        display.alpha = 0
        UIView.animate(withDuration:0.3, animations: { [weak self] in
            display.alpha = 1
            self?.display?.alpha = 0
        }) { [weak self] _ in
            self?.display?.removeFromSuperview()
            self?.display = display
        }
    }
    
    private func newDisplay() -> UIView {
        let display = UIView()
        display.translatesAutoresizingMaskIntoConstraints = false
        display.isUserInteractionEnabled = false
        view.addSubview(display)
        
        let chart = UIView()
        chart.isUserInteractionEnabled = false
        chart.translatesAutoresizingMaskIntoConstraints = false
        display.addSubview(chart)
        
        var angle = CGFloat()
        
        let maskPath = CGMutablePath()
        maskPath.addArc(center:CGPoint(x:26, y:26), radius:19, startAngle:0.001, endAngle:0, clockwise:false)
        let mask = CAShapeLayer()
        mask.frame = view.bounds
        mask.path = maskPath
        mask.lineWidth = 10
        mask.strokeColor = UIColor.black.cgColor
        mask.fillColor = UIColor.clear.cgColor
        chart.layer.mask = mask
        
        var top = CGFloat(130)
        
        items[index].1.enumerated().forEach {
            let delta = .pi * 2 * CGFloat($0.element.percent)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:CGPoint(x:26, y:26))
            path.addArc(center:CGPoint(x:26, y:26), radius:25, startAngle:angle, endAngle:radius, clockwise:false)
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = view.bounds
            layer.path = path
            layer.lineWidth = 0.5
            layer.strokeColor = UIColor.black.cgColor
            if $0.offset == items[index].1.count - 1 {
                layer.fillColor = UIColor.velvetBlue.cgColor
            } else {
                layer.fillColor = UIColor(white:1, alpha:0.6).cgColor
            }
            chart.layer.addSublayer(layer)
            angle = radius
            
            let column = UILabel()
            column.translatesAutoresizingMaskIntoConstraints = false
            column.textColor = .black
            column.font = .systemFont(ofSize:13, weight:.light)
            column.text = $0.element.name
            display.addSubview(column)
            
            let progress = UIView()
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.backgroundColor = UIColor(cgColor:layer.fillColor!)
            progress.layer.cornerRadius = 3
            progress.isUserInteractionEnabled = false
            display.addSubview(progress)
            
            column.topAnchor.constraint(equalTo:display.topAnchor, constant:top).isActive = true
            column.leftAnchor.constraint(equalTo:display.leftAnchor, constant:12).isActive = true
            column.rightAnchor.constraint(equalTo:progress.leftAnchor).isActive = true
            
            progress.heightAnchor.constraint(equalToConstant:12).isActive = true
            progress.centerYAnchor.constraint(equalTo:column.centerYAnchor).isActive = true
            progress.rightAnchor.constraint(equalTo:display.rightAnchor, constant:-12).isActive = true
            progress.widthAnchor.constraint(
                equalToConstant:(view.bounds.width - 120) * CGFloat($0.element.percent)).isActive = true
            
            top += 30
        }
        preferredContentSize.height = top + 5
        display.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        display.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        display.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        display.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        chart.topAnchor.constraint(equalTo:display.topAnchor, constant:20).isActive = true
        chart.leftAnchor.constraint(equalTo:display.leftAnchor, constant:10).isActive = true
        chart.widthAnchor.constraint(equalToConstant:52).isActive = true
        chart.heightAnchor.constraint(equalToConstant:52).isActive = true
        return display
    }
    
    @objc private func highlight() { view.alpha = 0.15 }
    @objc private func unhighlight() { view.alpha = 1 }
    
    @objc private func open() {
        extensionContext?.open(URL(string:"velvetroom:")!, completionHandler:nil)
    }
    
    @objc private func showNext() {
        index = index < items.count - 1 ? index + 1 : 0
        Widget.index = index
        update()
    }
    
    @objc private func showPrevious() {
        index = index > 0 ? index - 1 : items.count - 1
        Widget.index = index
        update()
    }
}
