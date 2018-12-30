import UIKit
import VelvetRoom

class View:UIViewController {
    let repository = Repository()
    private weak var selected:Board! { didSet { fireSchedule() } }
    private weak var progressButton:ProgressView!
    private weak var titleLabel:UILabel!
    private weak var boards:UIView!
    private weak var boardsBottom:NSLayoutConstraint!
    private weak var boardsRight:NSLayoutConstraint!
    private weak var newLeft:NSLayoutConstraint!
    private weak var progressLeft:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        repository.list = { boards in DispatchQueue.main.async { self.list(boards) } }
        repository.select = { board in DispatchQueue.main.async { self.open(board) } }
        listenKeyboard()
        DispatchQueue.global(qos:.background).async { self.repository.load() }
    }
    
    func open(_ board:Board) {
        selected = board
        progressButton.progress = board.progress
        titleLabel.text = board.name
        newLeft.constant = view.bounds.width * -0.16
        progressLeft.constant = view.bounds.width * -0.32
        boardsRight.constant = view.bounds.width
        UIView.animate(withDuration:0.5) {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 1
        }
    }
    
    func scheduleUpdate(_ board:Board? = nil) {
        DispatchQueue.global(qos:.background).async { self.repository.scheduleUpdate(board ?? self.selected) }
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
        titleLabel.font = .bold(16)
        titleLabel.textColor = .white
        titleLabel.alpha = 0
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
        
        newButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        newButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        newLeft = newButton.leftAnchor.constraint(equalTo:view.leftAnchor)
        newLeft.isActive = true
        
        progressButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        progressButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        progressButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        progressLeft = progressButton.leftAnchor.constraint(equalTo:view.rightAnchor)
        progressLeft.isActive = true
        
        listButton.topAnchor.constraint(equalTo:newButton.topAnchor).isActive = true
        listButton.leftAnchor.constraint(equalTo:progressButton.rightAnchor).isActive = true
        listButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        listButton.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.16).isActive = true
        
        titleLabel.heightAnchor.constraint(equalToConstant:30).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:newButton.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo:newButton.rightAnchor, constant:20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo:progressButton.leftAnchor).isActive = true
        
        boardsScroll.topAnchor.constraint(equalTo:newButton.bottomAnchor).isActive = true
        boardsScroll.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        boardsScroll.rightAnchor.constraint(equalTo:boards.rightAnchor).isActive = true
        
        boards.bottomAnchor.constraint(equalTo:boardsScroll.bottomAnchor).isActive = true
        boards.topAnchor.constraint(equalTo:boardsScroll.topAnchor).isActive = true
        boards.leftAnchor.constraint(equalTo:boardsScroll.leftAnchor).isActive = true
        boards.widthAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        
        boardsRight = boardsScroll.rightAnchor.constraint(equalTo:view.rightAnchor)
        boardsBottom = boardsScroll.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        boardsRight.isActive = true
        boardsBottom.isActive = true
        
        if #available(iOS 11.0, *) {
            newButton.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            newButton.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func list(_ boards:[Board]) {
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
        UIApplication.shared.keyWindow!.endEditing(true)
        present(NewView(), animated:true)
    }
    
    @objc private func showList() {
        newLeft.constant = 0
        progressLeft.constant = 0
        boardsRight.constant = 0
        UIView.animate(withDuration:0.4) {
            self.view.layoutIfNeeded()
            self.titleLabel.alpha = 0
        }
    }
}
