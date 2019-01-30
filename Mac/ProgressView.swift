import AppKit

class ProgressView:NSView {
    private weak var marker:NSLayoutXAxisAnchor!
    private var slices = [ProgressSliceView]()
    
    var chart = [(String, Float)]() { didSet {
        while chart.count < slices.count { slices.removeLast().removeFromSuperview() }
        while chart.count > slices.count {
            let slice = ProgressSliceView()
            addSubview(slice)
            slice.topAnchor.constraint(equalTo:topAnchor).isActive = true
            slice.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
            slice.leftAnchor.constraint(
                equalTo:slices.isEmpty ? marker : slices.last!.rightAnchor, constant:2).isActive = true
            slices.append(slice)
        }
        layoutSubtreeIfNeeded()
        chart.enumerated().forEach {
            slices[$0.offset].width?.isActive = false
            slices[$0.offset].width = slices[$0.offset].widthAnchor.constraint(equalTo:widthAnchor, multiplier:
                CGFloat($0.element.1))
            slices[$0.offset].width!.isActive = true
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            context.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }) { }
    } }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.clear.cgColor
        layer!.cornerRadius = 2
        heightAnchor.constraint(equalToConstant:18).isActive = true
        
        let marker = NSView()
        marker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(marker)
        marker.leftAnchor.constraint(equalTo:leftAnchor, constant:-2).isActive = true
        self.marker = marker.leftAnchor
    }
    
    required init?(coder:NSCoder) { return nil }
}
