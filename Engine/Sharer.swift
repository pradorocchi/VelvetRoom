import Foundation
import CoreImage

public class Sharer {
    public class func export(_ board:Board) -> CGImage {
        let filter = CIFilter(name:"CIQRCodeGenerator")!
        filter.setValue("H", forKey:"inputCorrectionLevel")
        filter.setValue(Data(board.id.utf8), forKey:"inputMessage")
        let ciImage = filter.outputImage!.transformed(by:CGAffineTransform(scaleX:14, y:14))
        return CIContext().createCGImage(ciImage, from:ciImage.extent)!
    }
}
