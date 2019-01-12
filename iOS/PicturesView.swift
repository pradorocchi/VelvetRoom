import UIKit
import VelvetRoom
import Photos

class PicturesView:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    private var caching:PHCachingImageManager?
    private var items:PHFetchResult<PHAsset>?
    private var size:CGSize!
    private let request = PHImageRequestOptions()
    private weak var collection:UICollectionView!
    
    init() {
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
        request.resizeMode = .fast
        request.isSynchronous = false
        request.deliveryMode = .fastFormat
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .velvetShade
        makeOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        let width = view.bounds.width + 1
        let itemSize = (width / floor(width / 100)) - 2
        size = CGSize(width:itemSize, height:itemSize)
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = size
        checkAuth()
    }
    
    func collectionView(_:UICollectionView, numberOfItemsInSection:Int) -> Int { return items?.count ?? 0 }
    
    func collectionView(_:UICollectionView, cellForItemAt index:IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier:"picture", for:index) as! PictureViewCell
        if let request = cell.request { caching?.cancelImageRequest(request) }
        cell.request = caching?.requestImage(for:items![(items!.count - 1) - index.item], targetSize:size,
                                             contentMode:.aspectFill, options:request) { image, _ in
            cell.request = nil
            cell.image.image = image
        }
        return cell
    }
    
    func collectionView(_:UICollectionView, didSelectItemAt index:IndexPath) {
        view.isUserInteractionEnabled = false
        caching?.requestImageData(for:items![(items!.count - 1) - index.item], options:request)
        { [weak self] data, _, _, _ in
            guard
                let data = data,
                let image = UIImage(data:data)
            else { return }
            self?.read(image)
        }
    }
    
    private func makeOutlets() {
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.isUserInteractionEnabled = false
        labelTitle.textColor = .white
        labelTitle.font = .systemFont(ofSize:14, weight:.regular)
        labelTitle.text = .local("PicturesView.title")
        view.addSubview(labelTitle)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "delete.pdf"), for:[])
        close.imageView!.contentMode = .center
        close.imageView!.clipsToBounds = true
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(close)
        
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 1
        flow.minimumInteritemSpacing = 1
        flow.sectionInset = UIEdgeInsets(top:1, left:1, bottom:20, right:1)
        let collection = UICollectionView(frame:.zero, collectionViewLayout:flow)
        collection.backgroundColor = .black
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.alwaysBounceVertical = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(PictureViewCell.self, forCellWithReuseIdentifier:"picture")
        view.addSubview(collection)
        self.collection = collection
        
        labelTitle.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        close.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        close.widthAnchor.constraint(equalToConstant:50).isActive = true
        close.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        collection.topAnchor.constraint(equalTo:close.bottomAnchor).isActive = true
        collection.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        collection.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            close.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            close.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func read(_ image:UIImage) {
        close()
        if let image = image.cgImage,
            let id = try? Sharer.load(image) {
            Application.view.repository.load(id)
        } else {
            Application.view.errors.add(Exception.imageNotValid)
        }
    }
    
    private func checkAuth() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { [weak self] status in if status == .authorized { self?.load() } }
        case .authorized: load()
        case .denied, .restricted: break
        }
    }
    
    private func load() {
        caching = PHCachingImageManager()
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let roll = PHAssetCollection.fetchAssetCollections(with:.smartAlbum, subtype:.smartAlbumUserLibrary,
                                                                     options:nil).firstObject else { return }
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format:"mediaType = %d", PHAssetMediaType.image.rawValue)
            self?.load(roll:roll, options:options)
        }
    }
    
    private func load(roll:PHAssetCollection, options:PHFetchOptions) {
        items = PHAsset.fetchAssets(in:roll, options:options)
        DispatchQueue.main.async { [weak self] in self?.collection.reloadData() }
    }
    
    @objc private func close() {
        caching?.stopCachingImagesForAllAssets()
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
}
