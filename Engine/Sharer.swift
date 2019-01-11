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
    
    public class func load(_ image:CGImage) throws -> String {
        let ciImage = CIImage(cgImage:image)
        if let raw = (CIDetector(ofType:CIDetectorTypeQRCode, context:nil, options:[CIDetectorAccuracy:
            CIDetectorAccuracyHigh])!.features(in:ciImage, options:
                nil).first { $0 is CIQRCodeFeature } as? CIQRCodeFeature)?.messageString,
            validate(raw) {
            return raw
        }
        throw Exception.invalidQRCode
    }
    
    public class func validate(_ id:String) -> Bool {
        return UUID(uuidString:id) != nil
    }
}
