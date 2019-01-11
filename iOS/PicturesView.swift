import UIKit
import VelvetRoom
import Photos

class PicturesView:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    private var caching:PHCachingImageManager?
    private var items:PHFetchResult<PHAsset>?
    private var size:CGSize!
    private let request = PHImageRequestOptions()
    
    init() {
        super.init(nibName:nil, bundle:nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .velvetShade
        makeOutlets()
    }
    
    func collectionView(_:UICollectionView, numberOfItemsInSection:Int) -> Int { return items?.count ?? 0 }
    
    func collectionView(_ collection:UICollectionView, cellForItemAt index:IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier:String(), for:index) as! PictureViewCell
        if let request = cell.request { caching?.cancelImageRequest(request) }
        cell.request = caching?.requestImage(for:items![index.item], targetSize:size,
                                             contentMode:.aspectFill, options:request) { image, _ in
            cell.request = nil
            cell.image.image = image
        }
        return cell
    }
    
    func collectionView(_:UICollectionView, didSelectItemAt index:IndexPath) {
        view.isUserInteractionEnabled = false
        caching?.requestImageData(for:items![index.item], options:request) { [weak self] data, _, _, _ in
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
        
        labelTitle.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        close.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        close.widthAnchor.constraint(equalToConstant:50).isActive = true
        close.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        if #available(iOS 11.0, *) {
            close.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            close.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func read(_ image:UIImage) {
        close()
//        if Sharer.validate(content) {
//            Application.view.repository.load(content)
//        } else {
//            Application.view.errors.add(Exception.imageNotValid)
//        }
    }
    
    @objc private func close() {
        caching?.stopCachingImagesForAllAssets()
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
    
    
    
    
    
    
    
    
    
    
    
    func startLoading() {
        if caching == nil {
            let width = bounds.width + 1
            let itemSize = (width / floor(width / 100)) - 2
            size = CGSize(width:itemSize, height:itemSize)
            (collectionViewLayout as! UICollectionViewFlowLayout).itemSize = size
            checkAuth()
        }
    }
    
    func collectionView(_:UICollectionView, cellForItemAt index:IndexPath) -> UICollectionViewCell {
        let cell:LibraryCell = dequeueReusableCell(
            withReuseIdentifier:String(describing:LibraryCell.self), for:index) as! LibraryCell
        if let request = cell.request { caching?.cancelImageRequest(request) }
        cell.request = caching?.requestImage(
        for:items![index.item], targetSize:size, contentMode:.aspectFill, options:request) { image, _ in
            cell.request = nil
            cell.image.image = image
        }
        return cell
    }
    
    func collectionView(_:UICollectionView, didSelectItemAt index:IndexPath) {
        self.isUserInteractionEnabled = false
        caching?.requestImageData(for:items![index.item], options:request) { [weak self] data, _, _, _ in
            guard
                let data = data,
                let image = UIImage(data:data)
                else { return }
            self?.view.read(image:image)
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
            options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending:false)]
            options.predicate = NSPredicate(format:"mediaType = %d", PHAssetMediaType.image.rawValue)
            self?.load(roll:roll, options:options)
        }
    }
    
    private func load(roll:PHAssetCollection, options:PHFetchOptions) {
        items = PHAsset.fetchAssets(in:roll, options:options)
        caching?.startCachingImages(for:items!.objects(at:IndexSet(integersIn:0 ..< items!.count)), targetSize:size,
                                    contentMode:.aspectFill, options:request)
        DispatchQueue.main.async { [weak self] in self?.reloadData() }
    }
}
