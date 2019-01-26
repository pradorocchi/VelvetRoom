import AppKit
import NotificationCenter

@objc(WidgetView) class WidgetView:NSViewController, NCWidgetProviding {
    private weak var effect:NSVisualEffectView!
//    private weak var name:UILabel!
    private weak var charts:NSView?
    private var items = [Widget]()
    private var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()/*
        let effect:NSVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetPrimary())
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
        button.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true*/
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
    
    private func empty() {/*
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize:14, weight:.light)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "No boards created."
        effect.contentView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true*/
    }
    
    private func render() {/*
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize:16, weight:.bold)
        name.textColor = .black
        effect.contentView.addSubview(name)
        self.name = name
        
        let nextButton = UIButton()
        nextButton.addTarget(self, action:#selector(showNext), for:.touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("▼", for:[])
        nextButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1), for:.normal)
        nextButton.setTitleColor(.black, for:.highlighted)
        nextButton.titleLabel!.font = .systemFont(ofSize:10, weight:.light)
        nextButton.titleEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:100)
        effect.contentView.addSubview(nextButton)
        
        let prevButton = UIButton()
        prevButton.addTarget(self, action:#selector(showPrev), for:.touchUpInside)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.setTitle("▲", for:[])
        prevButton.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1), for:.normal)
        prevButton.setTitleColor(.black, for:.highlighted)
        prevButton.titleLabel!.font = .systemFont(ofSize:10, weight:.light)
        prevButton.titleEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:100)
        effect.contentView.addSubview(prevButton)
        
        name.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        name.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        nextButton.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant:150).isActive = true
        
        prevButton.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        prevButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        prevButton.bottomAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant:150).isActive = true*/
    }
    
    private func display() {/*
        name.text = items[index].name
        self.charts?.removeFromSuperview()
        
        let charts = UIView()
        charts.isUserInteractionEnabled = false
        charts.translatesAutoresizingMaskIntoConstraints = false
        effect.contentView.addSubview(charts)
        self.charts = charts
        
        charts.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        charts.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        charts.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-40).isActive = true
        
        var left = charts.leftAnchor
        let longest = items[index].columns.reduce(Float()) { max($0, $1) }
        items[index].columns.enumerated().forEach {
            let bar = UIView()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.isUserInteractionEnabled = false
            bar.backgroundColor = $0.offset == items[index].columns.count - 1 ? #colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1) : #colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 1, alpha: 1).withAlphaComponent(0.3)
            bar.layer.cornerRadius = 4
            bar.layer.borderWidth = 1
            bar.layer.borderColor = UIColor(white:0, alpha:0.1).cgColor
            charts.addSubview(bar)
            
            bar.leftAnchor.constraint(equalTo:left, constant:5).isActive = true
            bar.topAnchor.constraint(equalTo:charts.topAnchor, constant:-5).isActive = true
            bar.heightAnchor.constraint(equalTo:charts.heightAnchor,
                                        multiplier:CGFloat($0.element / longest),
                                        constant:25).isActive = true
            bar.widthAnchor.constraint(equalToConstant:22).isActive = true
            left = bar.rightAnchor
        }
        charts.rightAnchor.constraint(equalTo:left).isActive = true*/
    }
    
    @objc private func highlight() { view.alphaValue = 0.15 }
    @objc private func unhighlight() { view.alphaValue = 1 }
    
    @objc private func open() {
        extensionContext?.open(URL(string:"velvetroom:")!, completionHandler:nil)
    }
    
    @objc private func showNext() {
        index = index < items.count - 1 ? index + 1 : 0
        Widget.index = index
        display()
    }
    
    @objc private func showPrev() {
        index = index > 0 ? index - 1 : items.count - 1
        Widget.index = index
        display()
    }
}
