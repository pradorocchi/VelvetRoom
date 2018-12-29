import UIKit
import VelvetRoom

class View:UIViewController {
    weak var selected:BoardView! {
        willSet {
            if let previous = selected {
                previous.isSelected = false
            }
        }
        didSet {
            selected.isSelected = true
            fireSchedule()
        }
    }
    let repository = Repository()
    private weak var titleLabel:UILabel!
    private weak var boards:UIView!
    private weak var boardsBottom:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.select(board) } }
        listenKeyboard()
        DispatchQueue.global(qos:.background).async { self.repository.load() }
    }
    
    func scheduleUpdate() {
        DispatchQueue.global(qos:.background).async { self.repository.scheduleUpdate(self.selected.board) }
    }
    
    func fireSchedule() {
        repository.fireSchedule()
    }
    
    private func makeOutlets() {
        let newButton = UIButton()
        newButton.addTarget(self, action:#selector(new), for:.touchUpInside)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setImage(#imageLiteral(resourceName: "new.pdf"), for:.normal)
        newButton.imageView!.clipsToBounds = true
        newButton.imageView!.contentMode = .center
        view.addSubview(newButton)
        
        let progressButton = ProgressView()
        view.addSubview(progressButton)
        
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setImage(#imageLiteral(resourceName: "delete.pdf"), for:.normal)
        deleteButton.imageView!.clipsToBounds = true
        deleteButton.imageView!.contentMode = .center
        deleteButton.isEnabled = false
        view.addSubview(deleteButton)
        
        let listButton = UIButton()
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setImage(#imageLiteral(resourceName: "list.pdf"), for:.normal)
        listButton.imageView!.clipsToBounds = true
        listButton.imageView!.contentMode = .center
        listButton.isEnabled = false
        view.addSubview(listButton)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = .light(15)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let boardsScroll = UIScrollView()
        boardsScroll.translatesAutoresizingMaskIntoConstraints = false
        boardsScroll.alwaysBounceVertical = true
        boardsScroll.indicatorStyle = .white
        view.addSubview(boardsScroll)
        
        let boards = UIView()
        boards.translatesAutoresizingMaskIntoConstraints = false
        boardsScroll.addSubview(boards)
        self.boards = boards
        
        newButton.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        newButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        newButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        progressButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        progressButton.rightAnchor.constraint(equalTo:newButton.leftAnchor).isActive = true
        progressButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        progressButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo:progressButton.leftAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        deleteButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        listButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        listButton.rightAnchor.constraint(equalTo:deleteButton.leftAnchor).isActive = true
        listButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        listButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:newButton.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-18).isActive = true
        
        boardsScroll.topAnchor.constraint(equalTo:newButton.bottomAnchor, constant:50).isActive = true
        boardsScroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        boardsScroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        boards.bottomAnchor.constraint(equalTo:boardsScroll.bottomAnchor).isActive = true
        boards.topAnchor.constraint(equalTo:boardsScroll.topAnchor).isActive = true
        boards.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        boards.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        boardsBottom = boardsScroll.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        boardsBottom.isActive = true
        
        if #available(iOS 11.0, *) {
            newButton.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            newButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func list(_ boards:[Board]) {
//        progress.clear()
//        deleteButton.isEnabled = false
//        canvas.removeSubviews()
        self.boards.subviews.forEach { $0.removeFromSuperview() }
        var top = self.boards.topAnchor
        boards.forEach { board in
            let view = BoardView(board)
            self.boards.addSubview(view)
            
            view.topAnchor.constraint(equalTo:top, constant:10).isActive = true
            view.leftAnchor.constraint(equalTo:self.boards.leftAnchor, constant:20).isActive = true
            view.rightAnchor.constraint(equalTo:self.boards.rightAnchor, constant:20).isActive = true
            top = view.bottomAnchor
        }
        if !boards.isEmpty {
            self.boards.bottomAnchor.constraint(equalTo:top, constant:10).isActive = true
        }
    }
    
    private func select(_ board:Board) {
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
    
    @objc private func new() {
        present(NewView(), animated:true)
    }
}
