import AppKit
import NotificationCenter

@objc(WidgetView) class WidgetView:NSViewController, NCWidgetProviding {
    private weak var name:NSTextField!
    private weak var charts:NSView?
    private var items = [Widget]()
    private var index = Int()
    
    override func loadView() { view = NSView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = NSSize(width:0, height:300)
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
        name.font = .systemFont(ofSize:16, weight:.bold)
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
        name.centerYAnchor.constraint(equalTo:view.topAnchor, constant:20).isActive = true
        
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
        name.stringValue = items[index].name/*
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
