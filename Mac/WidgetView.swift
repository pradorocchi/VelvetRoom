import AppKit
import NotificationCenter

@objc(WidgetView) class WidgetView:NSViewController, NCWidgetProviding {
    private weak var name:NSTextField!
    private weak var chart:NSView?
    private var items = [Widget]()
    private var index = Int()
    
    override func loadView() { view = NSView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = NSSize(width:0, height:320)
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func empty() {
        let label = NSTextField()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isBezeled = false
        label.isEditable = false
        label.font = .systemFont(ofSize:16, weight:.ultraLight)
        label.alignment = .center
        label.stringValue = "No boards created"
        view.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
    }
    
    private func render() {
        let name = NSTextField()
        name.backgroundColor = .clear
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isBezeled = false
        name.isEditable = false
        name.font = .systemFont(ofSize:18, weight:.regular)
        name.alignment = .center
        view.addSubview(name)
        self.name = name
        
        let nextButton = NSButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.image = NSImage(named:"next")
        nextButton.setButtonType(.momentaryChange)
        nextButton.imageScaling = .scaleNone
        nextButton.isBordered = false
        nextButton.title = String()
        nextButton.keyEquivalent = String(Character(UnicodeScalar(NSRightArrowFunctionKey)!))
        nextButton.target = self
        nextButton.action = #selector(showNext)
        view.addSubview(nextButton)
        
        let previousButton = NSButton()
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.image = NSImage(named:"previous")
        previousButton.setButtonType(.momentaryChange)
        previousButton.imageScaling = .scaleNone
        previousButton.isBordered = false
        previousButton.title = String()
        previousButton.keyEquivalent = String(Character(UnicodeScalar(NSLeftArrowFunctionKey)!))
        previousButton.target = self
        previousButton.action = #selector(showPrevious)
        view.addSubview(previousButton)
        
        name.leftAnchor.constraint(equalTo:previousButton.rightAnchor).isActive = true
        name.rightAnchor.constraint(equalTo:nextButton.leftAnchor).isActive = true
        name.centerYAnchor.constraint(equalTo:nextButton.centerYAnchor).isActive = true
        
        nextButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        nextButton.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-8).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant:50).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        previousButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        previousButton.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant:50).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant:40).isActive = true
    }
    
    private func display() {
        name.stringValue = items[index].name
        let chart = newChart()
        if #available(OSX 10.12, *) {
            chart.alphaValue = 0
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                chart.alphaValue = 1
                self.chart?.alphaValue = 0
            }) {
                self.chart?.removeFromSuperview()
                self.chart = chart
            }
        } else {
            self.chart?.removeFromSuperview()
            self.chart = chart
        }
    }
    
    private func newChart() -> NSView {
        let chart = NSView()
        chart.wantsLayer = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chart)
        
        var angle = CGFloat()
        let center = CGPoint(x:view.bounds.midX - 8, y:view.bounds.midY - 20)
        
        let maskPath = CGMutablePath()
        maskPath.addArc(center:center, radius:105, startAngle:0.001, endAngle:0, clockwise:false)
        let mask = CAShapeLayer()
        mask.frame = view.bounds
        mask.path = maskPath
        mask.lineWidth = 36
        mask.strokeColor = NSColor.black.cgColor
        mask.fillColor = NSColor.clear.cgColor
        chart.layer!.mask = mask
        
        items[index].columns.enumerated().forEach {
            let delta = .pi * -2 * CGFloat($0.element)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:center)
            path.addArc(center:center, radius:120, startAngle:angle, endAngle:radius, clockwise:true)
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = view.bounds
            layer.path = path
            layer.lineWidth = 4
            layer.strokeColor = NSColor.black.cgColor
            if $0.offset == items[index].columns.count - 1 {
                layer.fillColor = NSColor.velvetBlue.cgColor
            } else {
                layer.fillColor = NSColor.velvetBlue.withAlphaComponent(0.2).cgColor
            }
            chart.layer!.addSublayer(layer)
            angle = radius
        }
        
        let path = CGMutablePath()
        path.addArc(center:center, radius:88, startAngle:0.001, endAngle:0, clockwise:false)
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path
        layer.lineWidth = 4
        layer.strokeColor = NSColor.black.cgColor
        chart.layer!.addSublayer(layer)
        
        chart.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        chart.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        chart.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        return chart
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
