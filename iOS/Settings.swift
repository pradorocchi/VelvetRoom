import UIKit
import VelvetRoom

class Settings:UIViewController {
    private weak var dark:UIButton!
    private weak var light:UIButton!
    private weak var labelTitle:UILabel!
    private weak var labelAppearance:UILabel!
    private weak var labelLight:UILabel!
    private weak var labelDark:UILabel!
    private weak var labelFont:UILabel!
    private weak var font:UILabel!
    private weak var slider:UISlider!
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOutlets()
        updateSkin()
        Skin.add(self)
    }
    
    private func makeOutlets() {
        let labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.font = .systemFont(ofSize:18, weight:.bold)
        labelTitle.text = .local("SettingsView.title")
        view.addSubview(labelTitle)
        self.labelTitle = labelTitle
        
        let labelAppearance = UILabel()
        labelAppearance.translatesAutoresizingMaskIntoConstraints = false
        labelAppearance.font = .systemFont(ofSize:16, weight:.medium)
        labelAppearance.text = .local("SettingsView.appearance")
        view.addSubview(labelAppearance)
        self.labelAppearance = labelAppearance
        
        let dark = UIButton()
        dark.addTarget(self, action:#selector(makeDark), for:.touchUpInside)
        dark.translatesAutoresizingMaskIntoConstraints = false
        dark.setImage(#imageLiteral(resourceName: "dark.pdf"), for:[])
        dark.imageView!.clipsToBounds = true
        dark.imageView!.contentMode = .center
        view.addSubview(dark)
        self.dark = dark
        
        let light = UIButton()
        light.addTarget(self, action:#selector(makeLight), for:.touchUpInside)
        light.translatesAutoresizingMaskIntoConstraints = false
        light.setImage(#imageLiteral(resourceName: "light.pdf"), for:[])
        light.imageView!.clipsToBounds = true
        light.imageView!.contentMode = .center
        view.addSubview(light)
        self.light = light
        
        let labelDark = UILabel()
        labelDark.translatesAutoresizingMaskIntoConstraints = false
        labelDark.font = .systemFont(ofSize:12, weight:.light)
        labelDark.text = .local("SettingsView.dark")
        labelDark.textAlignment = .center
        view.addSubview(labelDark)
        self.labelDark = labelDark
        
        let labelLight = UILabel()
        labelLight.translatesAutoresizingMaskIntoConstraints = false
        labelLight.font = .systemFont(ofSize:12, weight:.light)
        labelLight.text = .local("SettingsView.light")
        labelLight.textAlignment = .center
        view.addSubview(labelLight)
        self.labelLight = labelLight
        
        let labelFont = UILabel()
        labelFont.translatesAutoresizingMaskIntoConstraints = false
        labelFont.font = .systemFont(ofSize:16, weight:.medium)
        labelFont.text = .local("SettingsView.font")
        view.addSubview(labelFont)
        self.labelFont = labelFont
        
        let font = UILabel()
        font.translatesAutoresizingMaskIntoConstraints = false
        font.font = .systemFont(ofSize:16, weight:.light)
        font.textAlignment = .right
        view.addSubview(font)
        self.font = font
        
        let slider = UISlider()
        slider.addTarget(self, action:#selector(changeFont), for:.valueChanged)
        slider.addTarget(self, action:#selector(saveFont), for:[.touchUpInside, .touchUpOutside, .touchCancel])
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 8
        slider.maximumValue = 32
        slider.minimumTrackTintColor = .velvetBlue
        slider.maximumTrackTintColor = UIColor(white:0.6, alpha:0.3)
        view.addSubview(slider)
        self.slider = slider
        
        let done = UIButton()
        done.layer.cornerRadius = 4
        done.backgroundColor = .velvetBlue
        done.translatesAutoresizingMaskIntoConstraints = false
        done.addTarget(self, action:#selector(close), for:.touchUpInside)
        done.setTitle(.local("SettingsView.done"), for:[])
        done.setTitleColor(.black, for:.normal)
        done.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        done.titleLabel!.font = .systemFont(ofSize:15, weight:.medium)
        view.addSubview(done)
        
        labelTitle.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        
        labelAppearance.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        labelAppearance.topAnchor.constraint(equalTo:labelTitle.bottomAnchor, constant:50).isActive = true
        
        dark.topAnchor.constraint(equalTo:labelAppearance.bottomAnchor, constant:20).isActive = true
        dark.rightAnchor.constraint(equalTo:view.centerXAnchor, constant:-30).isActive = true
        dark.widthAnchor.constraint(equalToConstant:50).isActive = true
        dark.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        light.topAnchor.constraint(equalTo:labelAppearance.bottomAnchor, constant:20).isActive = true
        light.leftAnchor.constraint(equalTo:view.centerXAnchor, constant:30).isActive = true
        light.widthAnchor.constraint(equalToConstant:50).isActive = true
        light.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        labelDark.centerXAnchor.constraint(equalTo:dark.centerXAnchor).isActive = true
        labelDark.topAnchor.constraint(equalTo:dark.bottomAnchor, constant:5).isActive = true
        
        labelLight.centerXAnchor.constraint(equalTo:light.centerXAnchor).isActive = true
        labelLight.topAnchor.constraint(equalTo:light.bottomAnchor, constant:5).isActive = true
        
        labelFont.topAnchor.constraint(equalTo:labelLight.bottomAnchor, constant:50).isActive = true
        labelFont.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        
        font.topAnchor.constraint(equalTo:labelDark.bottomAnchor, constant:50).isActive = true
        font.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        
        slider.topAnchor.constraint(equalTo:labelFont.bottomAnchor, constant:20).isActive = true
        slider.leftAnchor.constraint(equalTo:view.leftAnchor, constant:20).isActive = true
        slider.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-20).isActive = true
        
        done.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        done.widthAnchor.constraint(equalToConstant:88).isActive = true
        done.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        if #available(iOS 11.0, *) {
            labelTitle.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant:20).isActive = true
            done.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant:-20).isActive = true
        } else {
            labelTitle.topAnchor.constraint(equalTo:view.topAnchor, constant:20).isActive = true
            done.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-20).isActive = true
        }
        
        slider.value = Float(Repository.shared.account.font)
        font.text = "\(Int(slider.value))"
        
        if Repository.shared.account.appearance == .light {
            changeLight()
        } else {
            changeDark()
        }
    }
    
    private func changeDark() {
        dark.alpha = 1
        light.alpha = 0.3
    }
    
    private func changeLight() {
        dark.alpha = 0.3
        light.alpha = 1
    }
    
    @objc private func updateSkin() {
        UIView.animate(withDuration:0.5) { [weak self] in
            self?.view.backgroundColor = Skin.shared.background
            self?.labelTitle.textColor = Skin.shared.text
            self?.labelAppearance.textColor = Skin.shared.text
            self?.labelDark.textColor = Skin.shared.text
            self?.labelLight.textColor = Skin.shared.text
            self?.labelFont.textColor = Skin.shared.text
            self?.font.textColor = Skin.shared.text
        }
    }
    
    @objc private func close() {
        view.isUserInteractionEnabled = false
        presentingViewController!.dismiss(animated:true)
    }
    
    @objc private func changeFont() {
        font.text = "\(Int(slider.value))"
    }
    
    @objc private func saveFont() {
        Repository.shared.change(Int(slider.value))
    }
    
    @objc private func makeDark() {
        changeDark()
        Repository.shared.change(.dark)
        Skin.update(.dark, font:Int(slider.value))
    }
    
    @objc private func makeLight() {
        changeLight()
        Repository.shared.change(.light)
        Skin.update(.light, font:Int(slider.value))
    }
}
