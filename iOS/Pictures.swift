import UIKit
import VelvetRoom
import Photos

class Pictures:Sheet, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var caching:PHCachingImageManager?
    private var items:PHFetchResult<PHAsset>?
    private var size = CGSize.zero
    private let request = PHImageRequestOptions()
    private weak var collection:UICollectionView!
    
    @discardableResult override init() {
        super.init()
        request.resizeMode = .fast
        request.isSynchronous = false
        request.deliveryMode = .fastFormat
        
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.textColor = Skin.shared.text
        labelTitle.font = .systemFont(ofSize:14, weight:.regular)
        labelTitle.text = .local("Pictures.title")
        addSubview(labelTitle)
        
        let close = Link(.local("Pictures.close"), target:self, selector:#selector(self.close))
        close.backgroundColor = .clear
        close.setTitleColor(Skin.shared.text.withAlphaComponent(0.6), for:.normal)
        close.setTitleColor(Skin.shared.text.withAlphaComponent(0.15), for:.highlighted)
        addSubview(close)
        
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 1
        flow.minimumInteritemSpacing = 1
        flow.sectionInset = UIEdgeInsets(top:1, left:1, bottom:40, right:1)
        let collection = UICollectionView(frame:.zero, collectionViewLayout:flow)
        collection.backgroundColor = Skin.shared.text.withAlphaComponent(0.1)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.alwaysBounceVertical = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(PicturesItem.self, forCellWithReuseIdentifier:"picture")
        addSubview(collection)
        self.collection = collection
        
        labelTitle.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        close.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        
        collection.topAnchor.constraint(equalTo:close.bottomAnchor, constant:20).isActive = true
        collection.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        collection.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            close.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor, constant:20).isActive = true
        } else {
            close.topAnchor.constraint(equalTo:topAnchor, constant:20).isActive = true
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.updateSize()
            self.collection.collectionViewLayout.invalidateLayout()
        }
        super.layoutSubviews()
    }
    
    override func ready() {
        updateSize()
        checkAuth()
    }
    
    func collectionView(_:UICollectionView, numberOfItemsInSection:Int) -> Int { return items?.count ?? 0 }
    
    func collectionView(_:UICollectionView, cellForItemAt:IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier:"picture", for:cellForItemAt) as! PicturesItem
        if let request = cell.request { caching?.cancelImageRequest(request) }
        cell.request = caching?.requestImage(for:items![(items!.count - 1) - cellForItemAt.item], targetSize:size,
                                             contentMode:.aspectFill, options:request) { image, _ in
            cell.request = nil
            cell.image.image = image
        }
        return cell
    }
    
    func collectionView(_:UICollectionView, didSelectItemAt:IndexPath) {
        isUserInteractionEnabled = false
        caching?.requestImageData(for:items![(items!.count - 1) - didSelectItemAt.item], options:request)
        { [weak self] data, _, _, _ in
            guard
                let data = data,
                let image = UIImage(data:data)
            else { return }
            self?.read(image)
        }
    }
    
    private func updateSize() {
        let itemSize = ((bounds.width + 1) / floor((bounds.width + 1) / 100)) - 2
        size = CGSize(width:itemSize, height:itemSize)
        (collection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = size
    }
    
    private func read(_ image:UIImage) {
        close()
        if let image = image.cgImage,
            let id = try? Sharer.load(image) {
            Repository.shared.load(id)
        } else {
            Alert.shared.add(Exception.imageNotValid)
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
    
    override func close() {
        caching?.stopCachingImagesForAllAssets()
        super.close()
    }
}
