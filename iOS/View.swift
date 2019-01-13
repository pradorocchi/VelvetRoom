import UIKit
import VelvetRoom

class View:UIViewController {
    let repository = Repository()
    let errors = Errors()
    weak var root:ItemView?
    private(set) weak var selected:Board! { didSet { fireSchedule() } }
    private(set) weak var progressButton:ProgressView!
    private(set) weak var canvas:UIView!
    private weak var emptyButton:UIButton!
    private weak var titleLabel:UILabel!
    private weak var boards:UIView!
    private weak var boardsBottom:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var boardsRight:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var loadLeft:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var progressLeft:NSLayoutConstraint! { willSet { newValue.isActive = true } }
    private weak var canvasWidth:NSLayoutConstraint? { didSet {
        oldValue?.isActive = false; canvasWidth!.isActive = true } }
    private weak var canvasHeight:NSLayoutConstraint? { didSet {
        oldValue?.isActive = false; canvasHeight!.isActive = true } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.open(board) } }
        repository.error = { error in DispatchQueue.main.async { self.errors.add(error) } }
        listenKeyboard()
        DispatchQueue.global(qos:.background).async { self.repository.load() }
    }
    
    func open(_ board:Board) {
        selected = board
        progressButton.progress = board.progress
        titleLabel.text = board.name
        loadLeft.constant = -192
        progressLeft.constant = -128
        boardsRight.constant = view.bounds.width
        (canvas.superview as! UIScrollView).scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated:false)
        canvas.alpha = 0
        UIView.animate(withDuration:0.5, animations: {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 1
        }) { _ in
            self.render(board)
            self.canvasChanged(0)
            UIView.animate(withDuration:0.35) {
                self.canvas.alpha = 1
            }
        }
    }
    
    func canvasChanged(_ animation:TimeInterval = 0.5) {
        createCard()
        canvas.layoutIfNeeded()
        align()
        UIView.animate(withDuration:animation) {
            self.canvas.layoutIfNeeded()
            self.canvas.superview!.layoutIfNeeded()
        }
    }
    
    func scheduleUpdate(_ board:Board? = nil) {
        DispatchQueue.global(qos:.background).async { self.repository.scheduleUpdate(board ?? self.selected) }
    }
    
    func fireSchedule() {
        repository.fireSchedule()
    }
    
    private func makeOutlets() {
        let boardsScroll = UIScrollView()
        boardsScroll.translatesAutoresizingMaskIntoConstraints = false
        boardsScroll.alwaysBounceVertical = true
        boardsScroll.indicatorStyle = .white
        view.addSubview(boardsScroll)
        
        let boards = UIView()
        boards.translatesAutoresizingMaskIntoConstraints = false
        boardsScroll.addSubview(boards)
        self.boards = boards
        
        let canvasScroll = UIScrollView()
        canvasScroll.translatesAutoresizingMaskIntoConstraints = false
        canvasScroll.alwaysBounceVertical = true
        canvasScroll.alwaysBounceHorizontal = true
        canvasScroll.indicatorStyle = .white
        view.addSubview(canvasScroll)
        
        let canvas = UIView()
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvasScroll.addSubview(canvas)
        self.canvas = canvas
        
        let bar = GradientView()
        view.addSubview(bar)
        
        let loadButton = UIButton()
        loadButton.addTarget(self, action:#selector(load(_:)), for:.touchUpInside)
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.setImage(#imageLiteral(resourceName: "import.pdf"), for:.normal)
        loadButton.imageView!.clipsToBounds = true
        loadButton.imageView!.contentMode = .center
        view.addSubview(loadButton)
        
        let newButton = UIButton()
        newButton.addTarget(self, action:#selector(new), for:.touchUpInside)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setImage(#imageLiteral(resourceName: "new.pdf"), for:.normal)
        newButton.imageView!.clipsToBounds = true
        newButton.imageView!.contentMode = .center
        view.addSubview(newButton)
        
        let helpButton = UIButton()
        helpButton.addTarget(self, action:#selector(help), for:.touchUpInside)
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        helpButton.setImage(#imageLiteral(resourceName: "help.pdf"), for:.normal)
        helpButton.imageView!.clipsToBounds = true
        helpButton.imageView!.contentMode = .center
        view.addSubview(helpButton)
        
        let progressButton = ProgressView()
        progressButton.addTarget(self, action:#selector(progress), for:.touchUpInside)
        view.addSubview(progressButton)
        self.progressButton = progressButton
        
        let listButton = UIButton()
        listButton.addTarget(self, action:#selector(showList), for:.touchUpInside)
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setImage(#imageLiteral(resourceName: "list.pdf"), for:.normal)
        listButton.imageView!.clipsToBounds = true
        listButton.imageView!.contentMode = .center
        view.addSubview(listButton)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = .bold(20)
        titleLabel.textColor = .velvetBlue
        titleLabel.alpha = 0
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let emptyButton = UIButton()
        emptyButton.layer.cornerRadius = 4
        emptyButton.backgroundColor = .velvetBlue
        emptyButton.translatesAutoresizingMaskIntoConstraints = false
        emptyButton.addTarget(self, action:#selector(new), for:.touchUpInside)
        emptyButton.setTitle(.local("View.emptyButton"), for:[])
        emptyButton.setTitleColor(.black, for:.normal)
        emptyButton.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        emptyButton.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        emptyButton.isHidden = true
        view.addSubview(emptyButton)
        self.emptyButton = emptyButton
        
        bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        newButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        newButton.widthAnchor.constraint(equalToConstant:64).isActive = true
        newButton.leftAnchor.constraint(equalTo:loadButton.rightAnchor).isActive = true
        
        helpButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant:64).isActive = true
        helpButton.leftAnchor.constraint(equalTo:newButton.rightAnchor).isActive = true
        
        loadButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        loadButton.widthAnchor.constraint(equalToConstant:64).isActive = true
        loadButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        loadLeft = loadButton.leftAnchor.constraint(equalTo:view.leftAnchor)
        
        progressButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        progressButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        progressButton.widthAnchor.constraint(equalToConstant:64).isActive = true
        progressLeft = progressButton.leftAnchor.constraint(equalTo:view.rightAnchor)
        
        listButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        listButton.leftAnchor.constraint(equalTo:progressButton.rightAnchor).isActive = true
        listButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        listButton.widthAnchor.constraint(equalToConstant:64).isActive = true
        
        titleLabel.heightAnchor.constraint(equalToConstant:30).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:newButton.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo:helpButton.rightAnchor, constant:32).isActive = true
        titleLabel.rightAnchor.constraint(equalTo:progressButton.leftAnchor).isActive = true
        
        boardsScroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        boardsScroll.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        
        boards.bottomAnchor.constraint(equalTo:boardsScroll.bottomAnchor).isActive = true
        boards.topAnchor.constraint(equalTo:boardsScroll.topAnchor).isActive = true
        boards.leftAnchor.constraint(equalTo:boardsScroll.leftAnchor).isActive = true
        boards.rightAnchor.constraint(equalTo:boardsScroll.rightAnchor).isActive = true
        boards.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        boardsRight = boardsScroll.rightAnchor.constraint(equalTo:view.rightAnchor)
        boardsBottom = boardsScroll.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        
        canvasScroll.topAnchor.constraint(equalTo:boardsScroll.topAnchor).isActive = true
        canvasScroll.bottomAnchor.constraint(equalTo:boardsScroll.bottomAnchor).isActive = true
        canvasScroll.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        canvasScroll.rightAnchor.constraint(equalTo:boardsScroll.leftAnchor).isActive = true

        canvas.bottomAnchor.constraint(equalTo:canvasScroll.bottomAnchor).isActive = true
        canvas.topAnchor.constraint(equalTo:canvasScroll.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo:canvasScroll.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo:canvasScroll.rightAnchor).isActive = true
        canvas.widthAnchor.constraint(greaterThanOrEqualTo:view.widthAnchor).isActive = true
        canvas.heightAnchor.constraint(greaterThanOrEqualTo:canvasScroll.heightAnchor).isActive = true
        
        emptyButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        emptyButton.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        emptyButton.widthAnchor.constraint(equalToConstant:88).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        if #available(iOS 11.0, *) {
            boardsScroll.contentInsetAdjustmentBehavior = .never
            canvasScroll.contentInsetAdjustmentBehavior = .never
            newButton.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            newButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func list(_ boards:[Board]) {
        self.boards.subviews.forEach { $0.removeFromSuperview() }
        (self.boards.superview as! UIScrollView).scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated:true)
        var top = self.boards.topAnchor
        boards.enumerated().forEach { board in
            let view = BoardView(board.element)
            self.boards.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top, constant:board.offset == 0 ? 60 : 10).isActive = true
            view.leftAnchor.constraint(equalTo:self.boards.leftAnchor, constant:20).isActive = true
            view.rightAnchor.constraint(equalTo:self.boards.rightAnchor, constant:20).isActive = true
            top = view.bottomAnchor
        }
        if boards.isEmpty {
            emptyButton.isHidden = false
        } else {
            emptyButton.isHidden = true
            self.boards.bottomAnchor.constraint(equalTo:top, constant:10).isActive = true
        }
        self.boards.layoutIfNeeded()
    }
    
    private func listenKeyboard() {
        NotificationCenter.default.addObserver(
        forName:UIResponder.keyboardWillChangeFrameNotification, object:nil, queue:.main) {
            if let rect = ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                rect.minY < self.view.bounds.height {
                self.boardsBottom.constant = -rect.height
            } else {
                self.boardsBottom.constant = 0
            }
            UIView.animate(withDuration:
            ($0.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0) {
                self.view.layoutIfNeeded()
            }
        }
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
            var bottom = CGFloat(60)
            
            var child = sibling
            sibling = sibling!.sibling
            while child != nil {
                child!.left.constant = right
                child!.top.constant = bottom
                
                bottom += child!.bounds.height + 10
                maxRight = max(maxRight, right + child!.bounds.width + 45)
                
                child = child!.child
            }
            
            maxBottom = max(bottom, maxBottom)
        }
        canvasWidth = canvas.widthAnchor.constraint(greaterThanOrEqualToConstant:maxRight - 40)
        canvasHeight = canvas.heightAnchor.constraint(greaterThanOrEqualToConstant:maxBottom + 20)
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
    
    @objc private func help() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(HelpView(), animated:true)
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
        progressButton.progress = 0
        loadLeft.constant = 0
        progressLeft.constant = 0
        boardsRight.constant = 0
        UIView.animate(withDuration:0.4, animations: {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 0
        }) { _ in
            self.canvas.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc private func progress() {
        UIApplication.shared.keyWindow!.endEditing(true)
        present(ChartView(selected), animated:true)
    }
    
    @objc private func newColumn(_ view:CreateView) {
        let column = ColumnView(repository.newColumn(selected))
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
        let card = CardView(try! repository.newCard(selected))
        card.child = view.child
        view.child = card
        canvas.addSubview(card)
        card.top.constant = view.top.constant
        card.left.constant = view.left.constant
        canvasChanged()
        card.beginEditing()
        scheduleUpdate()
        progressButton.progress = selected.progress
    }
}
