import UIKit

open class CropPhoto {
    
}

public extension CropPhoto {
    
    public struct Params {
        public let image: UIImage
        public let cropRect: CGRect?
        
        public init(image: UIImage, cropRect: CGRect?) {
            self.image = image
            self.cropRect = cropRect
        }
    }
    
}

