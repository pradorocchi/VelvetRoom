import UIKit
import VelvetRoom
import AVFoundation

class CameraView:UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private weak var display:UIView!
    private var session:AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .velvetShade
        makeOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        let session = AVCaptureSession()
        session.sessionPreset = .hd1280x720
        let preview = AVCaptureVideoPreviewLayer(session:session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = display.bounds
        self.session = session
        
        let device:AVCaptureDevice?
        if #available(iOS 10.0, *) {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for:.video, position:.back)
        } else {
            device = AVCaptureDevice.default(for:.video)
        }
        if let input = device,
            let deviceInput = try? AVCaptureDeviceInput(device:input) {
            session.addInput(deviceInput)
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        if output.availableMetadataObjectTypes.contains(.qr) {
            output.metadataObjectTypes = [.qr]
        }
        output.setMetadataObjectsDelegate(self, queue:.global(qos:.background))
        
        display.layer.addSublayer(preview)
        session.startRunning()
    }
    
    func metadataOutput(_:AVCaptureMetadataOutput, didOutput objects:[AVMetadataObject], from:AVCaptureConnection) {
        guard let content = (objects.first as? AVMetadataMachineReadableCodeObject)?.stringValue else { return }
        DispatchQueue.main.async { [weak self] in self?.read(content) }
    }
    
    private func makeOutlets() {
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.textColor = .white
        labelTitle.font = .systemFont(ofSize:14, weight:.regular)
        labelTitle.text = .local("CameraView.title")
        view.addSubview(labelTitle)
        
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(#imageLiteral(resourceName: "delete.pdf"), for:[])
        close.imageView!.contentMode = .center
        close.imageView!.clipsToBounds = true
        close.addTarget(self, action:#selector(self.close), for:.touchUpInside)
        view.addSubview(close)
        
        let display = UIView()
        display.isUserInteractionEnabled = false
        display.translatesAutoresizingMaskIntoConstraints = false
        display.backgroundColor = .black
        view.addSubview(display)
        self.display = display
        
        let finder = UIView()
        finder.isUserInteractionEnabled = false
        finder.translatesAutoresizingMaskIntoConstraints = false
        finder.layer.borderWidth = 1
        finder.layer.borderColor = UIColor.white.cgColor
        view.addSubview(finder)
        
        display.topAnchor.constraint(equalTo:close.bottomAnchor).isActive = true
        display.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        display.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        display.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        finder.centerXAnchor.constraint(equalTo:display.centerXAnchor).isActive = true
        finder.centerYAnchor.constraint(equalTo:display.centerYAnchor).isActive = true
        finder.widthAnchor.constraint(equalToConstant:200).isActive = true
        finder.heightAnchor.constraint(equalToConstant:200).isActive = true
        
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
    
    private func read(_ content:String) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        close()
        if Sharer.validate(content) {
            Application.view.repository.load(content)
        } else {
            Application.view.alert.add(Exception.imageNotValid)
        }
    }
    
    @objc private func close() {
        session.stopRunning()
        session = nil
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
}
