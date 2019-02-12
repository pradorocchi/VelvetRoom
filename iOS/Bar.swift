import UIKit

class Bar:UIView {
    static let shared = Bar()
    private weak var loadLeft:NSLayoutConstraint!
    private weak var chartLeft:NSLayoutConstraint!
    private weak var title:UILabel!
    
    private init() {
        super.init(frame:.zero)
        
        let load = Button(#imageLiteral(resourceName: "import.pdf"), target:self, selector:#selector(self.load))
        addSubview(load)
        
        let new = Button(#imageLiteral(resourceName: "new.pdf"), target:self, selector:#selector(self.new))
        addSubview(new)
        
        let settings = Button(#imageLiteral(resourceName: "settings.pdf"), target:self, selector:#selector(self.settings))
        addSubview(settings)
        
        let help = Button(#imageLiteral(resourceName: "help.pdf"), target:self, selector:#selector(self.help))
        addSubview(help)
        
        let chart = Button(#imageLiteral(resourceName: "chart.pdf"), target:self, selector:#selector(self.chart))
        addSubview(chart)
        
        let search = Button(#imageLiteral(resourceName: "search.pdf"), target:Search.shared, selector:#selector(Search.shared.active))
        addSubview(search)
        
        let list = Button(#imageLiteral(resourceName: "list.pdf"), target:self, selector:#selector(self.list))
        addSubview(list)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .bold(20)
        title.alpha = 0
        addSubview(title)
        self.title = title
        
        load.topAnchor.constraint(equalTo:topAnchor).isActive = true
        loadLeft = load.leftAnchor.constraint(equalTo:leftAnchor)
        loadLeft.isActive = true
        
        new.topAnchor.constraint(equalTo:topAnchor).isActive = true
        new.leftAnchor.constraint(equalTo:load.rightAnchor).isActive = true
        
        settings.topAnchor.constraint(equalTo:topAnchor).isActive = true
        settings.leftAnchor.constraint(equalTo:new.rightAnchor).isActive = true
        
        help.topAnchor.constraint(equalTo:topAnchor).isActive = true
        help.leftAnchor.constraint(equalTo:settings.rightAnchor).isActive = true
        
        chart.topAnchor.constraint(equalTo:new.topAnchor).isActive = true
        chartLeft = chart.leftAnchor.constraint(equalTo:rightAnchor)
        chartLeft.isActive = true
        
        search.topAnchor.constraint(equalTo:new.topAnchor).isActive = true
        search.leftAnchor.constraint(equalTo:chart.rightAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo:new.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo:search.rightAnchor).isActive = true
        
        title.heightAnchor.constraint(equalToConstant:30).isActive = true
        title.centerYAnchor.constraint(equalTo:new.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo:help.rightAnchor, constant:30).isActive = true
        title.rightAnchor.constraint(equalTo:chart.leftAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc private func load() {
        UIApplication.shared.keyWindow!.endEditing(true)
        App.shared.present({
            $0.view.tintColor = .black
            $0.addAction(UIAlertAction(title:.local("View.loadCamera"), style:.default) { _ in
                App.shared.present(Camera(), animated:true)
            })
            $0.addAction(UIAlertAction(title:.local("View.loadLibrary"), style:.default) { _ in
                App.shared.present(Pictures(), animated:true)
            })
            $0.addAction(UIAlertAction(title:.local("View.loadCancel"), style:.cancel))
            
            $0.popoverPresentationController?.sourceView = self
            $0.popoverPresentationController?.sourceRect = .zero
            $0.popoverPresentationController?.permittedArrowDirections = .any
            return $0
        } (UIAlertController(title:.local("View.loadTitle"), message:.local("View.loadMessage"),
                             preferredStyle:.actionSheet)), animated:true)
    }
    
    @objc private func new() {
        
    }
    
    @objc private func settings() {
        
    }
    
    @objc private func help() {
        
    }
    
    @objc private func chart() {
        
    }
    
    @objc private func list() {
        
    }
}
