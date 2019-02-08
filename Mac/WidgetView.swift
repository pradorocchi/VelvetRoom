import AppKit
import NotificationCenter

@objc(WidgetView) class WidgetView:NSViewController, NCWidgetProviding {
    private weak var name:NSTextField!
    private weak var display:NSView?
    private var items = [(String,[WidgetItem])]()
    private var index = Int()
    
    override func loadView() { view = NSView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        preferredContentSize = NSSize(width:0, height:100)
    }
    
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        items = Widget.items.map { ($0, $1) }.sorted {
            $0.0.compare($1.0, options:.caseInsensitive) == .orderedAscending }
        if true || items.isEmpty {
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
    
    private func empty() {
        let image = NSImageView()
        image.image = NSImage(named:"widget")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        view.addSubview(image)
        
        image.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
    }
    
    private func render() {
        let name = NSTextField()
        name.backgroundColor = .clear
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isBezeled = false
        name.isEditable = false
        name.font = .systemFont(ofSize:20, weight:.bold)
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
        
        name.leftAnchor.constraint(equalTo:view.leftAnchor, constant:62).isActive = true
        name.topAnchor.constraint(equalTo:view.topAnchor, constant:14).isActive = true
        
        nextButton.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:6).isActive = true
        nextButton.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-2).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant:40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        previousButton.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:6).isActive = true
        previousButton.leftAnchor.constraint(equalTo:view.leftAnchor, constant:-6).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant:40).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant:40).isActive = true
    }
    
    private func update() {
        name.stringValue = items[index].0
        let display = newDisplay()
        display.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            display.alphaValue = 1
            self.display?.alphaValue = 0
        }) { [weak self] in
            self?.display?.removeFromSuperview()
            self?.display = display
        }
    }
    
    private func newDisplay() -> NSView {
        let display = NSView()
        display.wantsLayer = true
        display.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(display)
        
        let chart = NSView()
        chart.wantsLayer = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        display.addSubview(chart)
        
        var angle = CGFloat()
        
        let maskPath = CGMutablePath()
        maskPath.addArc(center:CGPoint(x:26, y:26), radius:19, startAngle:0.001, endAngle:0, clockwise:false)
        let mask = CAShapeLayer()
        mask.frame = view.bounds
        mask.path = maskPath
        mask.lineWidth = 10
        mask.strokeColor = NSColor.black.cgColor
        mask.fillColor = NSColor.clear.cgColor
        chart.layer!.mask = mask
        
        var top = CGFloat(80)
        
        items[index].1.enumerated().forEach {
            let delta = .pi * -2 * CGFloat($0.element.percent)
            let radius = delta + angle
            let path = CGMutablePath()
            path.move(to:CGPoint(x:26, y:26))
            path.addArc(center:CGPoint(x:26, y:26), radius:25, startAngle:angle, endAngle:radius, clockwise:true)
            path.closeSubpath()
            let layer = CAShapeLayer()
            layer.frame = view.bounds
            layer.path = path
            layer.lineWidth = 0.5
            layer.strokeColor = NSColor(white:0, alpha:0.4).cgColor
            if $0.offset == items[index].1.count - 1 {
                layer.fillColor = NSColor.velvetBlue.cgColor
            } else {
                layer.fillColor = NSColor.textColor.withAlphaComponent(0.2).cgColor
            }
            chart.layer!.addSublayer(layer)
            angle = radius
            
            let column = NSTextField()
            column.lineBreakMode = .byTruncatingTail
            column.stringValue = $0.element.name
            column.backgroundColor = .clear
            column.translatesAutoresizingMaskIntoConstraints = false
            column.isBezeled = false
            column.isEditable = false
            column.font = .systemFont(ofSize:13, weight:.light)
            display.addSubview(column)
            
            let progress = NSView()
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.wantsLayer = true
            progress.layer!.cornerRadius = 3
            progress.layer!.backgroundColor = layer.fillColor
            display.addSubview(progress)
            
            column.topAnchor.constraint(equalTo:display.topAnchor, constant:top).isActive = true
            column.heightAnchor.constraint(equalToConstant:20).isActive = true
            column.leftAnchor.constraint(equalTo:display.leftAnchor).isActive = true
            column.rightAnchor.constraint(equalTo:progress.leftAnchor).isActive = true
            
            progress.heightAnchor.constraint(equalToConstant:12).isActive = true
            progress.centerYAnchor.constraint(equalTo:column.centerYAnchor).isActive = true
            progress.rightAnchor.constraint(equalTo:display.rightAnchor, constant:-8).isActive = true
            progress.widthAnchor.constraint(
                equalToConstant:(view.bounds.width - 100) * CGFloat($0.element.percent)).isActive = true

            top += 30
        }
        
        display.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        display.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        display.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        display.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        chart.topAnchor.constraint(equalTo:display.topAnchor).isActive = true
        chart.leftAnchor.constraint(equalTo:display.leftAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant:52).isActive = true
        chart.heightAnchor.constraint(equalToConstant:52).isActive = true
        preferredContentSize = NSSize(width:0, height:min(320, top + 40))
        return display
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
