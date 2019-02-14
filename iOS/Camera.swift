import UIKit
import VelvetRoom
import AVFoundation

class Camera:Sheet, AVCaptureMetadataOutputObjectsDelegate {
    private weak var display:UIView!
    private var session:AVCaptureSession!
    
    @discardableResult override init() {
        super.init()
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.textColor = Skin.shared.text
        labelTitle.font = .systemFont(ofSize:14, weight:.regular)
        labelTitle.text = .local("Camera.title")
        addSubview(labelTitle)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "delete.pdf"), for:[])
        close.imageView!.contentMode = .center
        close.imageView!.clipsToBounds = true
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        addSubview(close)
        
        let display = UIView()
        display.isUserInteractionEnabled = false
        display.translatesAutoresizingMaskIntoConstraints = false
        display.backgroundColor = .black
        addSubview(display)
        self.display = display
        
        let finder = UIView()
        finder.isUserInteractionEnabled = false
        finder.translatesAutoresizingMaskIntoConstraints = false
        finder.layer.borderWidth = 1
        finder.layer.borderColor = UIColor.white.cgColor
        finder.layer.cornerRadius = 4
        addSubview(finder)
        
        display.topAnchor.constraint(equalTo:close.bottomAnchor).isActive = true
        display.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        display.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        display.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        
        finder.centerXAnchor.constraint(equalTo:display.centerXAnchor).isActive = true
        finder.centerYAnchor.constraint(equalTo:display.centerYAnchor).isActive = true
        finder.widthAnchor.constraint(equalToConstant:200).isActive = true
        finder.heightAnchor.constraint(equalToConstant:200).isActive = true
        
        labelTitle.centerYAnchor.constraint(equalTo:close.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo:close.rightAnchor).isActive = true
        
        close.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        close.widthAnchor.constraint(equalToConstant:50).isActive = true
        close.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        if #available(iOS 11.0, *) {
            close.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            close.topAnchor.constraint(equalTo:topAnchor).isActive = true
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func ready() {
        let session = AVCaptureSession()
        session.sessionPreset = .hd1280x720
        session.addInput({
            try! AVCaptureDeviceInput(device:{
                if #available(iOS 10.0, *) {
                    return AVCaptureDevice.default(.builtInWideAngleCamera, for:.video, position:.back)!
                } else {
                    return AVCaptureDevice.default(for:.video)!
                }
            } ())
        } ())
        session.addOutput(AVCaptureMetadataOutput())
        session.outputs.compactMap( { $0 as? AVCaptureMetadataOutput } ).forEach( {
            $0.metadataObjectTypes = $0.availableMetadataObjectTypes.contains(.qr) ? [.qr] : $0.metadataObjectTypes
            $0.setMetadataObjectsDelegate(self, queue:.global(qos:.background))
        } )
        display.layer.addSublayer({
            $0.videoGravity = .resizeAspectFill
            $0.frame = display.bounds
            return $0
        }(AVCaptureVideoPreviewLayer(session:session)) )
        session.startRunning()
        self.session = session
    }
    
    func metadataOutput(_:AVCaptureMetadataOutput, didOutput:[AVMetadataObject], from:AVCaptureConnection) {
        session.stopRunning()
        guard let content = (didOutput.first as? AVMetadataMachineReadableCodeObject)?.stringValue else { return }
        DispatchQueue.main.async { [weak self] in self?.read(content) }
    }
    
    private func read(_ content:String) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        close()
        if Sharer.validate(content) {
            Repository.shared.load(content)
        } else {
            Alert.shared.add(Exception.imageNotValid)
        }
    }
}
