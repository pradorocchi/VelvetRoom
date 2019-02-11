import UIKit
import VelvetRoom

@UIApplicationMain class App:UIViewController, UIApplicationDelegate {
    static private(set) weak var shared:App!
    var window:UIWindow?
    private weak var splash:Splash?
    private var margin = UIEdgeInsets.zero
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = self
        App.shared = self
        return true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            margin = view.safeAreaInsets
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) { margin = view.safeAreaInsets }
        
        let splash = Splash()
        view.addSubview(splash)
        self.splash = splash
        
        splash.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        splash.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        splash.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        splash.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        Repository.shared.error = { Alert.shared.add($0) }
        Skin.add(self, selector:#selector(updateSkin))
        DispatchQueue.global(qos:.background).async {
            Repository.shared.load()
            DispatchQueue.main.async {
                self.outlets()
                DispatchQueue.global(qos:.background).async {
                    Skin.update()
                }
            }
        }
    }
    
    override func viewWillTransition(to:CGSize, with:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:to, with:with)
        if List.shared.right.constant > 0 {
            List.shared.right.constant = to.width
        }
    }
    
    private func outlets() {
        let list = List.shared
        let canvas = Canvas.shared
        let gradientTop = Gradient([0, 1])
        let gradientBottom = Gradient([1, 0])
        let progress = Progress.shared
        let search = Search.shared
        
        view.addSubview(list)
        view.addSubview(canvas)
        view.addSubview(gradientTop)
        view.addSubview(gradientBottom)
        view.addSubview(progress)
        view.addSubview(search)
        
        gradientTop.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        gradientTop.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        gradientTop.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        gradientTop.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        gradientBottom.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        gradientBottom.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        gradientBottom.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        gradientBottom.heightAnchor.constraint(equalToConstant:20).isActive = true
        
        list.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        list.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        
        canvas.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        canvas.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:list.leftAnchor).isActive = true
        
        progress.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-10).isActive = true
        progress.leftAnchor.constraint(equalTo:view.leftAnchor, constant:5).isActive = true
        progress.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-5).isActive = true
        
        search.leftAnchor.constraint(equalTo:view.leftAnchor, constant:10).isActive = true
        search.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-10).isActive = true
    }
    
    private func render(_ board:Board) {
        canvas.subviews.forEach { $0.removeFromSuperview() }
        root = nil
        var sibling:ItemView?
        board.columns.enumerated().forEach { (index, item) in
            let column = ColumnView(item)
            if sibling == nil {
                root = column
            } else {
                sibling!.sibling = column
            }
            canvas.addSubview(column)
            var child:ItemView = column
            sibling = column
            
            board.cards.filter( { $0.column == index } ).sorted(by: { $0.index < $1.index } ).forEach {
                let card = CardView($0)
                canvas.addSubview(card)
                child.child = card
                child = card
            }
        }
        
        let buttonColumn = CreateView(#selector(newColumn(_:)))
        canvas.addSubview(buttonColumn)
        
        if root == nil {
            root = buttonColumn
        } else {
            sibling!.sibling = buttonColumn
        }
    }
    
    private func align() {
        var maxRight = CGFloat(10)
        var maxBottom = CGFloat()
        var sibling = root
        while sibling != nil {
            let right = maxRight
            var bottom = CGFloat(60 + safeTop)
            
            var child = sibling
            sibling = sibling!.sibling
            while child != nil {
                child!.left.constant = right
                child!.top.constant = bottom
                
                bottom += child!.bounds.height + 30
                maxRight = max(maxRight, right + child!.bounds.width + 45)
                
                child = child!.child
            }
            
            maxBottom = max(bottom, maxBottom)
        }
        canvasWidth = canvas.widthAnchor.constraint(greaterThanOrEqualToConstant:maxRight - 40)
        canvasHeight = canvas.heightAnchor.constraint(greaterThanOrEqualToConstant:maxBottom + 20 + safeBottom)
    }
    
    private func createCard() {
        guard !(root is CreateView), !(root!.child is CreateView) else { return }
        let create = CreateView(#selector(newCard(_:)))
        create.child = root!.child
        root!.child = create
        canvas.addSubview(create)
        create.top.constant = root!.top.constant
        create.left.constant = root!.left.constant
    }
    
    @objc private func updateSkin() {
        view.backgroundColor = Application.skin.background
        canvasScroll.indicatorStyle = Application.skin.scroll
    }
    
    @objc private func help() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(HelpView(), animated:true)
    }
    
    @objc private func settings() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(SettingsView(), animated:true)
    }
    
    @objc private func new() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(NewView(), animated:true)
    }
    
    @objc private func load(_ button:UIButton) {
        UIApplication.shared.keyWindow!.endEditing(true)
        let alert = UIAlertController(title:.local("View.loadTitle"), message:.local("View.loadMessage"),
                                      preferredStyle:.actionSheet)
        alert.view.tintColor = .black
        alert.addAction(UIAlertAction(title:.local("View.loadCamera"), style:.default) { _ in
            self.present(CameraView(), animated:true)
        })
        alert.addAction(UIAlertAction(title:.local("View.loadLibrary"), style:.default) { _ in
            self.present(PicturesView(), animated:true)
        })
        alert.addAction(UIAlertAction(title:.local("View.loadCancel"), style:.cancel))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = button
            popover.sourceRect = button.bounds
            popover.permittedArrowDirections = .up
        }
        present(alert, animated:true)
    }
    
    @objc private func showList() {
        UIApplication.shared.keyWindow!.endEditing(true)
        progress.chart = []
        loadLeft.constant = 0
        chartLeft.constant = 0
        boardsRight.constant = 0
        UIView.animate(withDuration:0.4, animations: {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 0
        }) { _ in
            self.canvas.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc private func beginSearch() {
        UIApplication.shared.keyWindow!.endEditing(true)
        search.active()
    }
    
    @objc private func chart() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(ChartView(selected!), animated:true)
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(Repository.shared.newColumn(selected!))
        column.sibling = view
        if root === view {
            root = column
        } else {
            var left = root
            while left!.sibling !== view {
                left = left!.sibling
            }
            left!.sibling = column
        }
        canvas.addSubview(column)
        column.top.constant = view.top.constant
        column.left.constant = view.left.constant
        canvasChanged()
        column.beginEditing()
        scheduleUpdate()
    }
    
    @objc private func newCard(_ view:CreateView) {
        let card = CardView(try! Repository.shared.newCard(selected!))
        card.child = view.child
        view.child = card
        canvas.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        scheduleUpdate()
        progress.chart = selected!.chart
    }
}
